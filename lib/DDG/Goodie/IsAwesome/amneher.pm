package DDG::Goodie::IsAwesome::amneher;
# ABSTRACT: amneher's first goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_amneher";
zci is_cached   => 1;

triggers start => "duckduckhack amneher";


handle remainder => sub {
    return if $_;
    return "amneher is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
