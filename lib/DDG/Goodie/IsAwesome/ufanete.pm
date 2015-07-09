package DDG::Goodie::IsAwesome::ufanete;
# ABSTRACT: ufanete's first Goodie

use strict;
use DDG::Goodie;

zci answer_type => "is_awesome_ufanete";
zci is_cached   => 1;

name "IsAwesome ufanete";
description "My first Goodie, it lets the world know that ufanete is awesome";
primary_example_queries "duckduckhack ufanete";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/ufanete.pm";
attribution github => ["https://github.com/ufanete", "ufanete"];

triggers start => "duckduckhack ufanete";

handle remainder => sub {

    return if $_;
    return "ufanete is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};



1;
