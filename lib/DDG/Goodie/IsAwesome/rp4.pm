package DDG::Goodie::IsAwesome::rp4;
# ABSTRACT: rp4's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_rp4";
zci is_cached   => 1;

triggers start => "duckduckhack rp4";

handle remainder => sub {
    return if $_;
    return "rp4 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
