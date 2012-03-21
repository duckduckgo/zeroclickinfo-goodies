package DDG::Goodie::Reverse;
# ABSTRACT: Reverse the order of chars in the remainder

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "Reverse";
triggers startend => "reverse";

handle remainder => sub { join('',reverse split(//,$_)) };

1;
