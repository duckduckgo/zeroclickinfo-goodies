package DDG::Goodie::IsAwesome::dl00;
# ABSTRACT: dl00's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_dl00";
zci is_cached   => 1;

name "IsAwesome dl00";
description "My first Goodie, it let's the world know that dl00 is indeed as awesome as he says he is";
primary_example_queries "duckduckhack dl00";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/dl00.pm";
attribution github => ["https://github.com/dl00", "dl00"];

triggers start => "duckduckhack dl00";

handle remainder => sub {
    return if $_;
    return "dl00 is awesome and successfully completed the initiation tutorial for DuckDuckHack."
};

1;
