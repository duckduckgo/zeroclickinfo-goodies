package DDG::Goodie::JohnCena;
# ABSTRACT: WHO IS CHAMP? A simple instant answer that informs people of who the champ really is.
# See https://duck.co/ia/view/john_cena

use strict;
use DDG::Goodie;

triggers start => 
    "who is champ", 
    "who's champ",
    "wrestler meme",
    "wwe meme",
    "john cena",
    "and his name is";

zci answer_type => 'john_cena';
zci is_cached => 1;

handle remainder => sub {

    return if $_;

    my $answer = 'JOHN CENA';

    return $answer,
        structured_answer => {
            id        => 'john_cena',
            name      => 'Answer',
            data      => {
                title      => $answer,
                subtitle   => 'YOUR TIME IS UP, MY TIME IS NOW'
            },
            meta      => {
                sourceName => 'Wikipedia',
                sourceUrl  => 'https://en.wikipedia.org/wiki/John_Cena'
            },
            templates => {
                group      => 'text'
            }
        };
};

1;
