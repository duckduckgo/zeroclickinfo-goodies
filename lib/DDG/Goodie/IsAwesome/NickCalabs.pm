package DDG::Goodie::IsAwesome::NickCalabs;
# ABSTRACT: NickCalabs's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_nick_calabs";
zci is_cached   => 1;

name "IsAwesome NickCalabs";
description "My first Goodie, it let's the world know that NickCalabs is awesome";
primary_example_queries "duckduckhack nickcalabs";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/NickCalabs.pm";
attribution github => ["https://github.com/nickcalabs", "NickCalabs"],
            twitter => "NickCalabs";

triggers start => "duckduckhack nickcalabs";

handle remainder => sub {
    return if $_;
    return "NickCalabs is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
