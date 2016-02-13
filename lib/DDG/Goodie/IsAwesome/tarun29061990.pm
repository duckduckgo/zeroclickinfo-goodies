package DDG::Goodie::IsAwesome::tarun29061990;
# ABSTRACT: tarun29061990's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_tarun29061990";
zci is_cached   => 1;

triggers start => "duckduckhack tarun29061990";

handle remainder => sub {
    return if $_;
    return "tarun29061990 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
