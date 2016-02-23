package DDG::Goodie::IsAwesome::wongalvis;
# ABSTRACT: wongalvis' first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_wongalvis";
zci is_cached   => 1;

triggers start => "duckduckhack wongalvis";

handle remainder => sub {
    return if $_;
    return "wongalvis is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
