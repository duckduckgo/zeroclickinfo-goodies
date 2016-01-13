package DDG::Goodie::IsAwesome::Lynbarry;
# ABSTRACT: Lynbarry's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_lynbarry";
zci is_cached   => 1;

triggers start => "duckduckhack lynbarry";

handle remainder => sub {
    return if $_;
    return "Lynbarry is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
