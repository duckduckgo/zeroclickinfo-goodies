package DDG::Goodie::IsAwesome::cap257zero;
# ABSTRACT: cap257zero's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_cap257zero";
zci is_cached   => 1;

triggers start => "duckduckhack cap257zero";

handle remainder => sub {
    return if $_;
    return "cap257zero is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
