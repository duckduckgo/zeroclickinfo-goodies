package DDG::Goodie::GibberishGenerator;
# ABSTRACT: generates random gibberish

use strict;
use DDG::Goodie;
use utf8;

triggers any => qw(nonsense gibberish);

zci is_cached => 0;
zci answer_type => "gibberish_generator";

handle query_lc => sub {
    my $query   = $_;

    return $result, structured_answer => {
        id   => 'gibberishgenerator',
        name => 'Answer',
        data => {
            title    => $result,
            subtitle => $formatted_input,
        },
        templates => {
            group  => 'text',
            moreAt => 0,
        }
    }
};

1;
