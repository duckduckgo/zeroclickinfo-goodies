package DDG::Goodie::IsAwesome::blainester;
# ABSTRACT: blainester's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_blainester";
zci is_cached   => 1;

triggers start => "duckduckhack blainester";

handle remainder => sub {
    return if $_;
    return "blainester is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
