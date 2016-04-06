package DDG::GoodieRole::NumberStyler::Format;
# ABSTRACT: An object representing a particular numerical notation.

use strict;
use warnings;

use Moo;
use Math::BigFloat;
use DDG::GoodieRole::NumberStyler::Number;
use CLDR::Number;

has [qw(decimal_sign group_sign)] => (
    is => 'ro',
    lazy => 1,
    builder => 1,
);

has _cldr_number => (
    is => 'ro',
    lazy => 1,
    builder => 1,
);
sub _build__cldr_number {
    my $self = shift;
    return CLDR::Number->new(locale => $self->locale);
}
sub _build_decimal_sign {
    return $_[0]->_cldr_number->decimal_sign;
}
sub _build_group_sign {
    return $_[0]->_cldr_number->group_sign;
}

has exponential => (
    is      => 'ro',
    default => sub { 'e' },
);

has number_regex => (
    is => 'lazy',
);

has locale => (
    is => 'ro',
    required => 1,
);

sub _build_number_regex {
    my $self = shift;
    my ($decimal, $thousands, $exponential) = (
        $self->decimal_sign,
        $self->group_sign,
        $self->exponential);

    return qr/-?[\d_ \Q$decimal\E\Q$thousands\E]+(?:\Q$exponential\E-?\d+)?/;
}

has _mantissa => (
    is   => 'ro',
    lazy => 1,
    builder => 1,
);

sub _build__mantissa {
    my $self = shift;
    my ($decimal, $thousands) = (
        quotemeta($self->decimal_sign),
        quotemeta($self->group_sign)
    );
    my $int_part = qr/(?<sign>[+-])?+(?<integer_part>(?:(?!0)\d{1,3}$thousands(?:\d{3}$thousands)*\d{3})|\d+)/;
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
        $self->group_sign,
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
