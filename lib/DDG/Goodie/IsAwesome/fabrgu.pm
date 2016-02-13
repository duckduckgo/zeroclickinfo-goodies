package DDG::Goodie::IsAwesome::fabrgu;
# ABSTRACT: fabrgu's first attempt at making a goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_fabrgu";
zci is_cached   => 1;

triggers start => "duckduckhack fabrgu";

handle remainder => sub {
    return if $_;
    return "fabrgu is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
