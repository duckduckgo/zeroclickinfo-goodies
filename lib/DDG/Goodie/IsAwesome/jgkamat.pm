package DDG::Goodie::IsAwesome::jgkamat;
# ABSTRACT: jgkamat's first Goodie

use strict;
use DDG::Goodie;

zci answer_type => "is_awesome_jgkamat";
zci is_cached   => 1;

# Triggers
triggers start => "duckduckhack jgkamat";

# Handle statement
handle remainder => sub {
    return if $_;
    return "jgkamat is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
