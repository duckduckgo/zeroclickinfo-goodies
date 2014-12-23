package DDG::Goodie::IsAwesome::mtoledo;
# ABSTRACT: mtoledo's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_mtoledo";
zci is_cached   => 1;

name "IsAwesome mtoledo";
description "My first Goodie";
primary_example_queries "duckduckhack mtoledo";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/mtoledo.pm";
attribution github => ["mtoledo", "Marcos Toledo"],
            twitter => "mtoledo";

triggers start => "duckduckhack mtoledo";

handle remainder => sub {
    return if $_;
    return "mtoledo has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
