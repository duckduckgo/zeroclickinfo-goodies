package DDG::Goodie::IsAwesome::pnodet;
#ABSTRACT: pnodet's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_pnodet";
zci is_cached   => 1;

triggers start => "duckduckhack pnodet";

handle remainder => sub {
    return if $_;
    return "pnodet is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
