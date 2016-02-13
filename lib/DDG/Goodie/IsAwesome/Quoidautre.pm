package DDG::Goodie::IsAwesome::Quoidautre;
#ABSTRACT: Quoidautre's first Goodie;

use DDG::Goodie;
use strict;

zci answer_type => "quoidautre";
zci is_cached   => 1;

triggers start => "duckduckhack quoidautre";

handle remainder => sub {
    return if $_;
    return "Quoidautre is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;
