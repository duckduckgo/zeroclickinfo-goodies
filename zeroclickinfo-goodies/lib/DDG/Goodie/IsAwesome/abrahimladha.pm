package DDG::Goodie::IsAwesome::abrahimladha;
# ABSTRACT: abrahimladha's first Goodie


use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_abrahimladha";
zci is_cached   => 1;

name "IsAwesome abrahimladha";
description "My first Goodie, it lets the world know that abrahimladha is awesome";
primary_example_queries "duckduckhack abrahimladha";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/abrahimladha.pm";
attribution github => ["https://github.com/abrahimladha", "abrahimladha"];

triggers start => "duckduckhack abrahimladha";

handle remainder => sub {
    return if $_;
    return "abrahimladha is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
