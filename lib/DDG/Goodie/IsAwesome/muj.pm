package DDG::Goodie::IsAwesome::muj;
# ABSTRACT: muj's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_muj";
zci is_cached   => 1;

# Triggers
triggers start => "duckduckhack muj";

# Handle statement
handle remainder => sub {
    return if$_;
    return "muj is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
