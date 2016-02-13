package DDG::Goodie::IsAwesome::scotbuff;
# ABSTRACT: scotbuff's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_scotbuff";
zci is_cached   => 1;

triggers start => "duckduckhack scotbuff";
handle remainder => sub {
    return if $_;
    return "scotbuff is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
