package DDG::Goodie::JohnCena;
# ABSTRACT: An extremely simple goodie with the purpose of informing people who the real champ is.
use DDG::Goodie;
use strict;

zci answer_type => 'john_cena';
zci is_cached => 1;
triggers any => 'who is champ', 'who\'s champ', 'define champ' , 'who can\'t I see', 'what is his name', 'what\'s his name', 'and his name is';

handle remainder => sub {  
    return "JOHN CENA";
};

1;
