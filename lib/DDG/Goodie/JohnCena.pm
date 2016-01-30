package DDG::Goodie::JohnCena;
# ABSTRACT: An extremely simple goodie that lets the user know who the champ really is.

use DDG::Goodie;
use strict;

zci answer_type => 'john_cena';
zci is_cached => 1;
triggers any => 'who is champ', 'and his name is';

handle remainder => sub {
    return "JOHN CENA";  
}