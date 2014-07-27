package DDG::GoodieRole::NumberStyle;

use strict;
use warnings;

use Moo;

has [qw(id decimal thousands exponential)] => (
    is => 'ro',
);

sub understands {
    my ($self, $number) = @_;
    my ($decimal, $thousands) = ($self->decimal, $self->thousands);

    # How do we know if a number is reasonable for this style?
    # This assumes the exponentials are not included to give better answers.
    return (
        # The number must contain only things we understand: numerals and separators for this style.
        $number =~ /^(\d|\Q$thousands\E|\Q$decimal\E)+$/
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

sub precision_of {
    my ($self, $number_text) = @_;
    my $decimal = $self->decimal;

    return ($number_text =~ /\Q$decimal\E(\d+)/) ? length($1) : 0;
}

sub for_computation {
    my ($self, $number_text) = @_;
    my ($decimal, $thousands, $exponential) = ($self->decimal, $self->thousands, $self->exponential);

    $number_text =~ s/\Q$thousands\E//g;    # Remove thousands seps, since they are just visual.
    $number_text =~ s/\Q$decimal\E/./g;     # Make sure decimal mark is something perl knows how to use.
    if ($number_text =~ s/^([\d$decimal$thousands]+)\Q$exponential\E([\d$decimal$thousands]+)$/$1e$2/ig) {
        # Convert to perl style exponentials and then make into human-style floats.
        $number_text = sprintf('%f', $number_text);
    }

    return $number_text;
}

sub for_display {
    my ($self, $number_text) = @_;
    my ($decimal, $thousands, $exponential) = ($self->decimal, $self->thousands, $self->exponential);

    if ($number_text =~ /(.*)\Q$exponential\E(.*)/i) {
        my $norm_exp = ($2 == int $2) ? int $2 : $2;
        $number_text = $self->for_display($1) . ' * 10^' . $self->for_display($norm_exp);
    } else {
        $number_text = reverse $number_text;
        $number_text =~ s/\./$decimal/g;    # Perl decimal mark to whatever we need.
        $number_text =~ s/(\d\d\d)(?=\d)(?!\d*\Q$decimal\E)/$1$thousands/g;
        $number_text = reverse $number_text;
    }

    return $number_text;
}

1;
