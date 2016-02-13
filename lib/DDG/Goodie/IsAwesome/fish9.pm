package DDG::Goodie::IsAwesome::fish9;
# ABSTRACT: fish9's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_fish9";
zci is_cached   => 1;

triggers start => "duckduckhack fish9";

handle remainder => sub {
    return if $_;
    return "fish9 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
