package DDG::Goodie::Unidecode;
# ABSTRACT: return an ASCII version of the search query

use strict;
use DDG::Goodie;
use Text::Unidecode;
use utf8;

triggers startend => "unidecode";

zci is_cached => 1;
zci answer_type => "convert_to_ascii";

handle remainder => sub {
    my $u = unidecode $_;
    # unidecode output sometimes contains trailing spaces
    $u =~ s/\s+$//;
    return $u,
    structured_answer => {
        data => {
            title => $u
        },
        templates => {
            group => "text"
        }
    }
};

1;
