package DDG::GoodieRole::NumberStyler;
# ABSTRACT: A role to allow Goodies to recognize and work with numbers in different notations.

use strict;
use warnings;

use Moo::Role;
use DDG::GoodieRole::NumberStyler::Format;

use List::Util qw( all first );

# If it could fit more than one the first in order gets preference.
my @known_styles = (
    DDG::GoodieRole::NumberStyler::Format->new({
            id        => 'perl',
            decimal   => '.',
            thousands => ',',
        }
    ),
    DDG::GoodieRole::NumberStyler::Format->new({
            id        => 'euro',
            decimal   => ',',
            thousands => '.',
        }
    ),
);

sub number_style_regex {
    my $return_regex = join '|', map { $_->number_regex } @known_styles;
    return qr/(?:$return_regex)/;
}

# Takes an array of numbers and attempts to parse them with a known format.
# If there are conflicting answers among the array, will return undef.
sub parse_numbers {
    my @numbers = @_;
    foreach my $test_style (@known_styles) {
        if (all { defined $test_style->parse_number($_) } @numbers) {
            return map { $test_style->parse_number($_) } @numbers;
        }
    }
    return;
}

sub parse_text_to_number {
    my $number = shift;
    my ($num) = parse_numbers($number);
    return $num;
}

1;
