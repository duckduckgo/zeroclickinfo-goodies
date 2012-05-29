package DDG::Goodie::Reverse;
# ABSTRACT: Reverse the order of chars in the remainder

use DDG::Goodie;

triggers startend => "reverse";

zci is_cached => 1;
zci answer_type => "reverse";

handle remainder => sub { qq|Reversed "$_": | . scalar reverse };

1;
