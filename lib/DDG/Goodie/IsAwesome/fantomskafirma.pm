package DDG::Goodie::IsAwesome::fantomskafirma;
# ABSTRACT: FantomskaFirma Goodie #1

use DDG::Goodie;

zci answer_type => "is_awesome_fantomskafirma";
zci is_cached   => 1;

name "IsAwesome fantomskafirma";
description "My first Goodie, it let's the world know that fantomskafirma is awesome";
primary_example_queries "duckduckhack fantomskafirma";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/fantomskafirma.pm";
attribution github => ["https://github.com/fantomskafirma", "fantomskafirma"],
            twitter => "fantomskafirma";

triggers start => "duckduckhack fantomskafirma", "fantomskafirma duckduckhack";

handle remainder => sub {
    return if $_;
    return "fantomskafirma is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
