package DDG::Goodie::IsAwesome::samph;
# ABSTRACT: samph's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_samph";
zci is_cached   => 1;

triggers start => "duckduckhack samph";


handle remainder => sub {
    return if $_;
    return "SamPH is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;
