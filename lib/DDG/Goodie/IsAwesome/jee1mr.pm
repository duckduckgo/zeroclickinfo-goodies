package DDG::Goodie::IsAwesome::jee1mr;
#ABSTRACT: jee1mr's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_jee1mr";
zci is_cached   => 1;

triggers start => "duckduckhack jee1mr";

handle remainder => sub {
    return if $_;
    return "jee1mr is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
