package DDG::Goodie::IsAwesome::FantomskaFirma;
# ABSTRACT: FantomskaFirma's first Goodie.

use DDG::Goodie;

zci answer_type => "is_awesome_fantomska_firma";
zci is_cached   => 1;

name "IsAwesome FantomskaFirma";
description "My first Goodie, it let's the world know that FantomskaFirma is awesome";
primary_example_queries "duckduckhack FantomskaFirma";
category "special";
topics "special_interest", "hacking";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/FantomskaFirma.pm";
attribution github => ["https://github.com/FantomskaFirma", "FantomskaFirma"],
            twitter => "@FantomskaFirma";

triggers start => "duckduckhack fantomskafirma";

handle remainder => sub {
    return if $_;
    return "FantomskaFirma is hacking this search result!";
};

1;
