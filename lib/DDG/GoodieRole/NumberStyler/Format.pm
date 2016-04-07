package DDG::GoodieRole::NumberStyler::Format;
# ABSTRACT: An object representing a particular numerical notation.

use strict;
use warnings;

use Moo;
use Math::BigFloat;
use DDG::GoodieRole::NumberStyler::Number;
use CLDR::Number;

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

sub _build_number_regex {
    my $self = shift;
    my $neutered_mantissa = _neuter_regex($self->_mantissa);
    my $exp = $self->exponential;
    return qr/$neutered_mantissa(?:$exp$neutered_mantissa)?/;
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

sub _neuter_regex {
    my $regex = shift;
    $regex =~ s/\(\?<\w+>/(?:/g;
    return $regex;
}

sub parse_number {
    my ($self, $number_text) = @_;
    my $raw = $number_text;
    my ($thousands, $exponential) = (
        $self->_cldr_number->group_sign,
        $self->exponential
    );
    $number_text =~ s/[ _]//g;    # Remove spaces and underscores as visuals.
    my ($num_int, $num_frac, $num_exp, $num_sign);
    my $mantissa = $self->_mantissa;
    my $neutered_mantissa = _neuter_regex($mantissa);
    if ($number_text =~ /^$mantissa\Q$exponential\E(?<exponent>$neutered_mantissa)$/i) {
        $num_exp = $+{exponent};
        $num_int = $+{integer_part};
        $num_frac = $+{fractional_part};
        $num_sign = $+{sign};
        $num_exp = $self->parse_number($num_exp);
    } elsif ($number_text =~ /^$mantissa$/) {
        $number_text =~ /^$mantissa$/;
        $num_int = $+{integer_part};
        $num_frac = $+{fractional_part};
        $num_sign = $+{sign};
    } else {
        # Didn't understand the number
        return;
    }
    $num_int =~ s/\Q$thousands\E//g if defined $num_int;
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
