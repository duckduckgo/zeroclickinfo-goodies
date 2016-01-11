package DDG::Goodie::IsAwesome::fantomskafirma;
# ABSTRACT: FantomskaFirma Goodie #1

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_fantomskafirma";
zci is_cached   => 1;

triggers start => "duckduckhack fantomskafirma", "fantomskafirma duckduckhack";

handle remainder => sub {
    return if $_;
    return "fantomskafirma is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
