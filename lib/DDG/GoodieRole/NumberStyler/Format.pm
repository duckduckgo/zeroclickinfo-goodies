package DDG::GoodieRole::NumberStyler::Format;
# ABSTRACT: An object representing a particular numerical notation.

use strict;
use warnings;

use Moo;
use Math::BigFloat;
use DDG::GoodieRole::NumberStyler::Number;

has [qw(id decimal thousands)] => (
    is => 'ro',
);

has exponential => (
    is      => 'ro',
    default => sub { 'e' },
);

has number_regex => (
    is => 'lazy',
);

sub _build_number_regex {
    my $self = shift;
    my ($decimal, $thousands, $exponential) = ($self->decimal, $self->thousands, $self->exponential);

    return qr/-?[\d_ \Q$decimal\E\Q$thousands\E]+(?:\Q$exponential\E-?\d+)?/;
}

sub understands {
    my ($self, $number) = @_;
    my ($decimal, $thousands, $exponential) = ($self->decimal, $self->thousands, $self->exponential);

    if ($number =~ /(.*)\Q$exponential\E(.*)/) {
        return $self->understands($1) && $self->understands($2);
    }
    # How do we know if a number is reasonable for this style?
    # This assumes the exponentials are not included to give better answers.
    return (
        # The number must contain only things we understand: numerals and separators for this style.
        $number =~ /^-?(|\d|_| |\Q$thousands\E|\Q$decimal\E)+$/
          && (
            # The number is not required to contain thousands separators
            $number !~ /\Q$thousands\E/
            || (
                # But if the number does contain thousands separators, they must delimit exactly 3 numerals.
                $number !~ /\Q$thousands\E\d{1,2}\b/
                && $number !~ /\Q$thousands\E\d{4,}/
                # And cannot follow a leading zero
                && $number !~ /^0\Q$thousands\E/
            ))
          && (
            # The number is not required to include decimal separators
            $number !~ /\Q$decimal\E/
            # But if one is included, it cannot be followed by another separator, whether decimal or thousands.
            || $number !~ /\Q$decimal\E(?:.*)?(?:\Q$decimal\E|\Q$thousands\E)/
          )) ? 1 : 0;
}

has _mantissa => (
    is   => 'ro',
    lazy => 1,
    builder => 1,
);

sub _build__mantissa {
    my $self = shift;
    my ($decimal, $thousands) = ($self->decimal, $self->thousands);
    my $int_part = qr/(?<integer_part>(?:\d{1,3}\Q$thousands\E(?:\d{3}\Q$thousands\E)*\d{3})|\d+)/;
    my $frac_part = qr/(?<fractional_part>\d+)/;
    return qr/(?:$int_part\Q$decimal\E$frac_part|$int_part\Q$decimal\E|\Q$decimal\E$frac_part|$int_part)/;
}

sub parse_number {
    my ($self, $number_text) = @_;
    my $raw = $number_text;
    return unless $self->understands($number_text);
    my ($thousands, $exponential) = ($self->thousands, $self->exponential);
    $number_text =~ s/[ _]//g;    # Remove spaces and underscores as visuals.
    my ($num_int, $num_frac, $num_exp);
    my $mantissa = $self->_mantissa;
    if ($number_text =~ /^$mantissa\Q$exponential\E(?<exponent>[+-]?.+)$/i) {
        $num_exp = $+{exponent};
        $num_int = $+{integer_part};
        $num_frac = $+{fractional_part};
        $num_exp = $self->parse_number($num_exp);
    } else {
        $number_text =~ /^$mantissa$/;
        $num_int = $+{integer_part};
        $num_frac = $+{fractional_part};
    }
    $num_int =~ s/\Q$thousands\E//g;
    return DDG::GoodieRole::NumberStyler::Number->new(
        exponent        => $num_exp,
        format          => $self,
        fractional_part => $num_frac,
        integer_part    => $num_int,
        raw             => $raw,
    );
}


1;
