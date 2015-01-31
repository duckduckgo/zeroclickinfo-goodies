package DDG::Goodie::IsAwesome::stefolof;
# ABSTRACT: stefolof's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_stefolof";
zci is_cached   => 1;

name "IsAwesome stefolof";
description "My first Goodie, it let's the world know that stefolof is awesome";
primary_example_queries "duckduckhack stefolof";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/stefolof.pm";
attribution github => ["https://github.com/stefolof", "stefolof"],
            twitter => "stefolof";

triggers start => "duckduckhack stefolof";

handle remainder => sub {
    return if $_;
    return "stefolof is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";

};

1;
