package DDG::Goodie::IsAwesome::valcrist73;
# ABSTRACT: valcrist73's first goodie
use strict; #used so Github can correctly identify the file as Perl5
use DDG::Goodie;

zci answer_type => "is_awesome_valcrist73";
zci is_cached   => 1;

name "IsAwesome valcrist73";
description "My first Goodie, it lets the english/spanish speaking world know that valcrist73 is specifically awesome";
primary_example_queries "duckduckhack valcrist73";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/valcrist73.pm";
attribution github => ["valcrist73", "Jonathan"];

triggers start => "duckduckhack valcrist73";

handle remainder => sub {
    return if $_;
    return "Valcrist73 is awesome and has successfully completed the DuckDuckHack Goodie tutorial! - Valcrist73 es genial y ha completado exitosamente el tutorial DuckDuckHack Goodie!";
};
1;