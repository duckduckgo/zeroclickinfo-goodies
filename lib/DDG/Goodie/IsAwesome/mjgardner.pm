package DDG::Goodie::IsAwesome::mjgardner;
# ABSTRACT: mjgardner's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_mjgardner";
zci is_cached   => 1;

triggers start => "duckduckhack mjgardner";

handle remainder => sub {
    return if $_;
    return "mjgardner is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
