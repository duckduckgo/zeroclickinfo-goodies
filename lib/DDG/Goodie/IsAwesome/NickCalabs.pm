package DDG::Goodie::IsAwesome::NickCalabs;
# ABSTRACT: NickCalabs's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_nick_calabs";
zci is_cached   => 1;

triggers start => "duckduckhack nickcalabs";

handle remainder => sub {
    return if $_;
    return "NickCalabs is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
