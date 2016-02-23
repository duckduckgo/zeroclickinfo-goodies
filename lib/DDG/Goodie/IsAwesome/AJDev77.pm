package DDG::Goodie::IsAwesome::AJDev77;
# ABSTRACT: AJDev77's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_ajdev77";
zci is_cached   => 1;

triggers start => "duckduckhack ajdev77";

handle remainder => sub {
    return if $_;
    return "AJDev77 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
