package DDG::Goodie::IsAwesome::javathunderman;
# ABSTRACT: JavaThunderMan's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome:javathunderman";
zci is_cached   => 1;

triggers start => "duckduckhack javathunderman";

handle remainder => sub {
    return if $_;
    return "javathunderman is awesome and has created a goodie!";
};

1;
