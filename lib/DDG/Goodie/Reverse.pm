package DDG::Goodie::Reverse;
# ABSTRACT: Reverse the order of chars in the remainder

use DDG::Goodie;

zci is_cached => 1;

triggers startend => 'reverse';

handle remainder => sub { reverse $_ };

1;
