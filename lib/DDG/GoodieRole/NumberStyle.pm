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

    return (
        $number =~ /^(\d|\Q$thousands\E|\Q$decimal\E)+$/
          # Only contains things we understand.
          && ($number !~ /\Q$thousands\E/ || ($number !~ /\Q$thousands\E\d{1,2}\b/ && $number !~ /\Q$thousands\E\d{4,}/))
          # You can leave out thousands breaks, but the ones you put in must be in the right place.
          # Note that this does not confirm that they put all the 'required' ones in.
          && ($number !~ /\Q$decimal\E/ || $number !~ /\Q$decimal\E(?:.*)?(?:\Q$decimal\E|\Q$thousands\E)/)
          # You can omit the decimal but you cannot have another decimal or thousands after:
    ) ? 1 : 0;
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
