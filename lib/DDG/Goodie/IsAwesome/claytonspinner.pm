package DDG::Goodie::IsAwesome::claytonspinner;
# ABSTRACT: claytonspinner's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_claytonspinner";
zci is_cached   => 1;

triggers start => "duckduckhack claytonspinner";

handle remainder => sub {
    return if $_;
    return "claytonspinner is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
