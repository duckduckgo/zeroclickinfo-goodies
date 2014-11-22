package DDG::Goodie::IsAwesome::kfloey;
# ABSTRACT: kfloey's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_kfloey";
zci is_cached   => 1;

name "IsAwesome kfloey";
description "My first Goodie, it let's the world know that kfloey is awesome";
primary_example_queries "duckduckhack kfloey";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/kfloey.pm";
attribution github => ["https://github.com/kfloey", "kfloey"];

triggers start => "duckduckhack kfloey";


handle remainder => sub {
    return if $_;
    return "kfloey is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
