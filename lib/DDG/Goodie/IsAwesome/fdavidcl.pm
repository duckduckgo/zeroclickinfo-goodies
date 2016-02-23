package DDG::Goodie::IsAwesome::fdavidcl;
# ABSTRACT: fdavidcl's First Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_fdavidcl";
zci is_cached   => 1;

triggers start => "duckduckhack fdavidcl";

handle remainder => sub {
    return if $_;
    return "fdavidcl is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
