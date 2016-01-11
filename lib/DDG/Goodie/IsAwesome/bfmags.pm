package DDG::Goodie::IsAwesome::bfmags;
# ABSTRACT: bfmags's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_bfmags";
zci is_cached   => 1;

# Triggers
triggers start => "duckduckhack bfmags";

handle remainder => sub {
    return if $_;
    return "bfmags is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
