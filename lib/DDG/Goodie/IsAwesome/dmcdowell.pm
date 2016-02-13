#ABSTRACT: dmcdowell's first Goodie

package DDG::Goodie::IsAwesome::dmcdowell;

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_dmcdowell";
zci is_cached   => 1;

triggers any => "duckduckhack dmcdowell";

handle remainder => sub {
    return if $_;
    return "dmcdowell is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
