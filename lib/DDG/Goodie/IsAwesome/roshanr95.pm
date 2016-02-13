package DDG::Goodie::IsAwesome::roshanr95;
# ABSTRACT: roshanr95's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_roshanr95";
zci is_cached   => 1;

triggers start => "duckduckhack roshanr95";

handle remainder => sub {
    return if $_;
    return "roshanr95 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;

