package DDG::Goodie::IsAwesome::mogigoma;
# ABSTRACT: Mogigoma's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_mogigoma";
zci is_cached   => 1;

triggers start => "duckduckhack mogigoma";

handle remainder => sub {
    return if $_;
    return "Mogigoma is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
