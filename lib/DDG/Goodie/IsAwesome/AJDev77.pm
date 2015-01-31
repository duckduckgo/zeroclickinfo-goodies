package DDG::Goodie::IsAwesome::AJDev77;
# ABSTRACT: AJDev77's first Goodie


use DDG::Goodie;

zci answer_type => "is_awesome_ajdev77";
zci is_cached   => 1;

name "IsAwesome AJDev77";
description "My first Goodie, it let's the world know that AJDev77 is awesome";
primary_example_queries "duckduckhack AJDev77";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/AJDev77.pm";
attribution github => ["https://github.com/AJDev77", "AJ"],
            twitter => "emposoft";

triggers start => "duckduckhack ajdev77";

handle remainder => sub {
    return if $_;
    return "AJDev77 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
