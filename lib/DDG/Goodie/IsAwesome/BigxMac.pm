package DDG::Goodie::IsAwesome::BigxMac;

use DDG::Goodie;

zci answer_type => "is_awesome_bigx_mac";
zci is_cached   => 1;

name "IsAwesome BigxMac";
description "My first Goodie, it let's the world know that BigxMac is awesome";
primary_example_queries "duckduckhack BigxMac";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/BigxMac.pm";
attribution github => ["BigxMac", "Jared S"],
            twitter => "twitterhandle";

triggers start => "duckduckhack bigxmac";

handle remainder => sub {
    return if $_;
    return "BigxMac is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
