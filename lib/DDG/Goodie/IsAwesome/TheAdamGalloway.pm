package DDG::Goodie::IsAwesome::TheAdamGalloway;
# ABSTRACT: TheAdamGalloway's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_the_adam_galloway";
zci is_cached   => 1;

name "IsAwesome TheAdamGalloway";
description "My first Goodie, it lets the world know that TheAdamGalloway is awesome";
primary_example_queries "duckduckhack TheAdamGalloway";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/TheAdamGalloway.pm";
attribution github => ["https://github.com/TheAdamGalloway", "TheAdamGalloway"],
            twitter => "TheAdamGalloway",
            web     => ['http://www.adamgalloway.me/'];

triggers start => "duckduckhack theadamgalloway";

handle remainder => sub {
    return if $_;
    return "TheAdamGalloway is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
