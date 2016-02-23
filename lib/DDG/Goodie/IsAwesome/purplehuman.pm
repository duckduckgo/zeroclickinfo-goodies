package DDG::Goodie::IsAwesome::purplehuman;
# ABSTRACT: purplehuman's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_purplehuman";
zci is_cached   => 1;

triggers start => "duckduckhack purplehuman";

handle remainder => sub {
    return if $_;
    return "purplehuman is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
