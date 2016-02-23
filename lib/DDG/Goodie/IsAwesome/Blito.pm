package DDG::Goodie::IsAwesome::Blito;
# ABSTRACT: Blito's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_blito";
zci is_cached   => 1;

triggers start => "duckduckhack blito";

handle remainder => sub {
    return if $_;
    return "Blito is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
