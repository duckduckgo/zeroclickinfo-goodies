package DDG::Goodie::IsAwesome::muj;
# ABSTRACT: muj's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_muj";
zci is_cached   => 1;

# Metadata.
name "IsAwesome muj";
description "My first Goodie, it lets the world know that muj is awesome!";
primary_example_queries "duckduckhack muj";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/muj.pm";
attribution github => ["https://github.com/muj", "Mujtaba Arshad"];

# Triggers
triggers start => "duckduckhack muj";

# Handle statement
handle remainder => sub {
    return if$_;
    return "muj is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
