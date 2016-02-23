package DDG::Goodie::IsAwesome::Marneus68;
# ABSTRACT: Marneus68's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_marneus68";
zci is_cached   => 1;

triggers start => "duckduckhack marneus68";

handle remainder => sub {
    return if $_;
    return "Marneus68 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
