package DDG::Goodie::IsAwesome::NicolasGeraud;
# ABSTRACT: NicolasGeraud's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_nicolas_geraud";
zci is_cached   => 1;

triggers start => "duckduckhack nicolasgeraud";

handle remainder => sub {
    return if $_;
    return "NicolasGeraud is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
