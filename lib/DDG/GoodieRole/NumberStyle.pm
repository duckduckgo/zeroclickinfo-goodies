package DDG::GoodieRole::NumberStyle;

use strict;
use warnings;

use Moo;

has [qw(id decimal thousands)] => (
    is => 'ro',
);

sub understands {
    my ($self, $number) = @_;
    my ($decimal, $thousands) = ($self->decimal, $self->thousands);

    # How do we know if a number is reasonable for this style?
    return (
        $number =~ /^(\d|\Q$thousands\E|\Q$decimal\E)+$/
          # The number must contain only things we understand: numerals and separators for this style.
          && (
            $number !~ /\Q$thousands\E/
            # The number is permitted not to contain thousands separators
            || (
                   $number !~ /\Q$thousands\E\d{1,2}\b/
                && $number !~ /\Q$thousands\E\d{4,}/
                # But if the number does contain thousands separators, they must delimit exactly 3 numerals.
                && $number !~ /^0\Q$thousands\E/
                # And they cannot follow a leading zero
            ))
          # Note: this does not confirm that they put all of the 'required' thousands separators in the number.
          && (
            $number !~ /\Q$decimal\E/
            # The number is permitted not to include decimal separators
            || $number !~ /\Q$decimal\E(?:.*)?(?:\Q$decimal\E|\Q$thousands\E)/
            # But if one is included, it cannot be followed by another separator, whether decimal or thousands.
          )) ? 1 : 0;
}

sub precision_of {
    my ($self, $number_text) = @_;
    my $decimal = $self->decimal;

    return ($number_text =~ /\Q$decimal\E(\d+)/) ? length($1) : 0;
}

sub for_computation {
    my ($self, $number_text) = @_;
    my ($decimal, $thousands) = ($self->decimal, $self->thousands);

    $number_text =~ s/\Q$thousands\E//g;    # Remove thousands seps, since they are just visual.
    $number_text =~ s/\Q$decimal\E/./g;     # Make sure decimal mark is something perl knows how to use.

    return $number_text;
}

sub for_display {
    my ($self, $number_text) = @_;
    my ($decimal, $thousands) = ($self->decimal, $self->thousands);    # Unpacked for easier regex-building

    $number_text = reverse $number_text;
    $number_text =~ s/\./$decimal/g;    # Perl decimal mark to whatever we need.
    $number_text =~ s/(\d\d\d)(?=\d)(?!\d*\Q$decimal\E)/$1$thousands/g;

    return scalar reverse $number_text;
}

1;
