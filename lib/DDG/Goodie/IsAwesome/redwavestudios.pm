package DDG::Goodie::IsAwesome::redwavestudios;
# ABSTRACT: redwavestudios' first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_redwavestudios";
zci is_cached   => 1;

triggers start => "duckduckhack redwavestudios";

handle remainder => sub {
    return if $_;
    return "redwavestudios is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
