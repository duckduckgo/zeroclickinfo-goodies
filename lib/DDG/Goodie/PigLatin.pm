package DDG::Goodie::PigLatin;
# ABSTRACT: convert a given string to pig latin

use strict;
use DDG::Goodie;
use Lingua::PigLatin 'piglatin';

triggers startend => 'pig latin', 'piglatin';

zci answer_type => "translation";
zci is_cached   => 1;

handle remainder => sub {
    my $query = shift;
    return unless $query;

    my $result = piglatin($query);
    return $result, structured_answer => {
        id   => 'pig_latin',
        name => 'Answer',
        data => {
            title    => "$result",
            subtitle => "Translate to Pig Latin: $query",
        },
        templates => {
            group  => 'text',
            moreAt => 0,
        },
      };
};

1;
