package DDG::Goodie::IsAwesome::kirshapps;
# ABSTRACT: Kirshapps' first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_kirshapps";
zci is_cached   => 1;

triggers start => "duckduckhack kirshapps";

handle remainder => sub {
    return if $_;
    return "kirshapps is awesome and has successfully completed the DuckDuckHack goodie tutorial!"
};

1;
