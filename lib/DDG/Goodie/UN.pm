package DDG::Goodie::UN;
# ABSTRACT: Gives a description for a given UN number

use strict;
use DDG::Goodie;
use Number::UN 'get_un';

use constant WPHREF => "https://en.wikipedia.org/wiki/List_of_UN_numbers_%04d_to_%04d";

triggers start => 'un';

zci is_cached => 1;
zci answer_type => 'united_nations';

handle remainder => sub {
    my $num = shift or return;
    $num =~ s/^number\s+//gi;
    return unless $num =~ /^\d+$/;

    my %un = get_un($num) or return;
    $un{description} =~ s/\.$//;

    return $un{description}, structured_answer => {
        data => {
            title => "UN Number: " . $un{number},
            description => $un{description}
        },
        meta => {
            sourceName => "Wikipedia",
            sourceUrl => wphref($num)
        },
        templates => {
            group => 'info',
            options => {
                moreAt => 1
            }
        }
    };
};

# Wikipedia attribution per CC-BY-SA
sub wphref {
    my $num = shift;
    my $lower = int($num / 100) * 100 + 1;
    my $upper = $lower + 99;
    return sprintf WPHREF, $lower, $upper;
}

1;
