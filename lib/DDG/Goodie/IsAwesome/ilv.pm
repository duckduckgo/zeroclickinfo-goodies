package DDG::Goodie::IsAwesome::ilv;
# ABSTRACT: ilv's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_ilv";
zci is_cached   => 1;

triggers start => "duckduckhack ilv";

handle remainder => sub {
    return if $_;
    return "ilv is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
