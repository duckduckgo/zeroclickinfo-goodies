package DDG::Goodie::IsAwesome::sagarhani;
#ABSTRACT: sagarhani's first Goodie


use DDG::Goodie;

zci answer_type => "is_awesome_sagarhani";
zci is_cached   => 1;


name "IsAwesome sagarhani";
description "My first Goodie, it let's the world know that sagarhani is awesome";
primary_example_queries "duckduckhack sagarhani";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/sagarhani.pm";
attribution github => ["https://github.com/sagarhani", "sagarhani"],
            twitter => "sagarhan_i";


triggers start => "duckduckhack sagarhani";


handle remainder => sub {
    return if $_;
    return "sagarhani is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
