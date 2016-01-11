package DDG::Goodie::IsAwesome::v0tti;
# ABSTRACT: My first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_v0tti";
zci is_cached   => 1;

triggers start => "duckduckhack v0tti";

handle remainder => sub {
    return if $_;
    return "v0tti is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
