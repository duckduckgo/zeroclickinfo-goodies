package DDG::Goodie::JohnCena;
# ABSTRACT: WHO IS CHAMP?

use DDG::Goodie;
use strict;

zci answer_type => 'john_cena';
zci is_cached => 1;
triggers any => 'who is champ', 'and his name is';

handle remainder => sub {
    
    return "JOHN CENA";
        
};

1;
