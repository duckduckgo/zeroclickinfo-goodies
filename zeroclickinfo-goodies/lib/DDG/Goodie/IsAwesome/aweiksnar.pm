package DDG::Goodie::IsAwesome::aweiksnar;
# ABSTRACT: aweiksnar's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_aweiksnar";
zci is_cached   => 1;

name "IsAwesome aweiksnar";
description "My first Goodie, it let's the world know that aweiksnar is awesome";
primary_example_queries "duckduckhack aweiksnar";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/aweiksnar.pm";
attribution github => ["aweiksnar", "Alex Weiksnar"];

triggers start => "duckduckhack aweiksnar";

handle remainder => sub {
    return if $_;
    return "aweiksnar is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
