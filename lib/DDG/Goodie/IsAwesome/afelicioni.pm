package DDG::Goodie::IsAwesome::afelicioni;
# ABSTRACT: afelicioni's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_afelicioni";
zci is_cached   => 1;

triggers start => "duckduckhack afelicioni";

handle remainder => sub {
    return if $_;
    return "afelicioni is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
