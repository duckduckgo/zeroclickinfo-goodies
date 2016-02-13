package DDG::Goodie::IsAwesome::mougias;
# ABSTRACT: mougias's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_mougias";
zci is_cached   => 1;

triggers start => "duckduckhack mougias";

handle remainder => sub {
    return if $_;
    return "mougias is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
