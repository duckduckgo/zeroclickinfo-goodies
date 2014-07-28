package DDG::GoodieRole::NumberStyler;

use strict;
use warnings;

use Moo::Role;
use DDG::GoodieRole::NumberStyle;

use List::Util qw( all first );

# If it could fit more than one the first in order gets preference.
my @known_styles = (
    DDG::GoodieRole::NumberStyle->new({
            id          => 'perl',
            decimal     => '.',
            thousands   => ',',
            exponential => 'e',
        }
    ),
    DDG::GoodieRole::NumberStyle->new({
            id          => 'euro',
            decimal     => ',',
            thousands   => '.',
            exponential => 'e',
        }
    ),
);

# Be sure to update the below, as well, if new styles are added.
my $perl_match = $known_styles[0]->number_regex;
my $euro_match = $known_styles[1]->number_regex;

sub number_style_regex {
    return qr/$perl_match|$euro_match/;
}

# Takes an array of numbers and returns which style to use for parse and display
# If there are conflicting answers among the array, will return undef.
sub number_style_for {
    my @numbers = @_;

    my $style;    # By default, assume we don't understand the numbers.

    STYLE:
    foreach my $test_style (@known_styles) {
        my $exponential = lc $test_style->exponential;    # Allow for arbitrary casing.
        if (all { $test_style->understands($_) } map { split /$exponential/, lc $_ } @numbers) {
            # All of our numbers fit this style.  Since we have them in preference order
            # we can pick it and move on.
            $style = $test_style;
            last STYLE;
        }
    }
    return $style;
}

1;
