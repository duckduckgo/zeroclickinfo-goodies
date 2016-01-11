package DDG::Goodie::IsAwesome::murz;
# ABSTRACT: Murz's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_murz";
zci is_cached   => 1;

# Triggers
triggers start => "duckduckhack murz";

# Handle statement
handle remainder => sub {
    return if $_;
    return "murz is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
