package DDG::GoodieRole::NumberStyler::Format;
# ABSTRACT: An object representing a particular numerical notation.

use strict;
use warnings;

use Moo;
use Math::BigFloat;
use DDG::GoodieRole::NumberStyler::Number;
use CLDR::Number;
use Regexp::Common;

has _cldr_number => (
    is => 'ro',
    lazy => 1,
    builder => 1,
);

sub _build__cldr_number {
    my $self = shift;
    return CLDR::Number->new(locale => $self->locale);
}

has exponential => (
    is      => 'ro',
    default => sub { 'e' },
);

has number_regex => (
    is => 'lazy',
);

has _re_components => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub _build__re_components {
    my $self = shift;
    my ($decimal, $plus, $minus) = (
        quotemeta $self->_cldr_number->decimal_sign,
        quotemeta $self->_cldr_number->plus_sign,
        quotemeta $self->_cldr_number->minus_sign
    );
    my ($radix, $sep, $sign) = (
        qr/[$decimal]/,
        $self->_sep,
        qr/[$plus$minus]?/,
    );
    return {
        radix => $radix,
        sep   => $sep,
        sign  => $sign,
    };
}

sub _build_number_regex {
    my $self = shift;
    my %re_components = %{$self->_re_components};
    my $re = $RE{num}{real}
        {-radix=>$re_components{radix}}
        {-sep=>$re_components{sep}}
        {-sign=>$re_components{sign}};
    return qr/(?:$re)/;
}

has locale => (
    is => 'ro',
    required => 1,
);

has _mantissa => (
    is   => 'ro',
    lazy => 1,
    builder => 1,
);

has _sep => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub _build__sep {
    my $self = shift;
    my $group = quotemeta $self->_cldr_number->group_sign;
    return qr/[$group _]?/;
}

sub _build__mantissa {
    my $self = shift;
    my ($positive, $negative, $decimal, $group) = map { quotemeta($_) } (
        $self->_cldr_number->plus_sign,
        $self->_cldr_number->minus_sign,
        $self->_cldr_number->decimal_sign,
        $self->_cldr_number->group_sign,
    );
    my $sign = qr/(?<sign>$positive|$negative)/;
    my $int_part = qr/$sign?+(?<integer_part>(?:(?!0)\d{1,3}$group(?:\d{3}$group)*\d{3})|\d+)/;
    my $frac_part = qr/(?<fractional_part>\d+)/;
    return qr/(?:$int_part$decimal$frac_part|$int_part$decimal|$decimal$frac_part|$int_part)/;
}

has _number_regex => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);

sub _build__number_regex {
    my $self = shift;
    my %re_components = %{$self->_re_components};
    my $re = $RE{num}{real}
        {-radix=>$re_components{radix}}
        {-sep=>$re_components{sep}}
        {-sign=>$re_components{sign}}
        {-keep};
    return qr/(?:$re)/;
}

sub _neuter_regex {
    my $regex = shift;
    $regex =~ s/\(\?<\w+>/(?:/g;
    return $regex;
}

sub parse_number {
    my ($self, $number_text) = @_;
    my $raw = $number_text;
    my ($sep, $exponential) = (
        $self->_sep,
        $self->exponential
    );
    my ($num_int, $num_frac, $num_exp, $num_sign);
    my $mantissa = $self->_mantissa;
    my $full_num = qr/^@{[$self->_number_regex]}$/;
    if ($number_text =~ $full_num) {
        $num_exp = $8;
        $num_int = $4;
        $num_frac = $6;
        $num_sign = $2;
        $num_exp = $self->parse_number($num_exp) if $num_exp;
    } elsif ($number_text =~ /^$mantissa$/) {
        $number_text =~ /^$mantissa$/;
        $num_int = $+{integer_part};
        $num_frac = $+{fractional_part};
        $num_sign = $+{sign};
    } else {
        # Didn't understand the number
        return;
    }
    $num_int =~ s/$sep//g if defined $num_int;
    return DDG::GoodieRole::NumberStyler::Number->new(
        exponent        => $num_exp,
        format          => $self,
        formatter       => $self->_cldr_number->decimal_formatter,
        fractional_part => $num_frac,
        integer_part    => $num_int,
        sign            => $num_sign,
        raw             => $raw,
    );
}

sub parse_numbers {
    my ($self, @numbers) = @_;
    return map { $self->parse_number($_) } @numbers;
}

my $perl = DDG::GoodieRole::NumberStyler::Format->new(
    locale => 'root',
);

sub parse_perl {
    my ($self, $number_text) = @_;
    my $num = $perl->parse_number($number_text) or return;
    $num->{format} = $self;
    return $num;
}

1;
