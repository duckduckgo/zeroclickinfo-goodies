package DDG::Goodie::IsAwesome::enricofoltran;
# ABSTRACT: enricofoltran's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_enricofoltran";
zci is_cached   => 1;

name "IsAwesome enricofoltran";
description "My first Goodie, it let's the world know that enricofoltran is awesome";
primary_example_queries "duckduckhack enricofoltran";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/enricofoltran.pm";
attribution github => ["https://github.com/enricofoltran", "enricofoltran"],
            twitter => "enricofoltran";

triggers start => "duckduckhack enricofoltran";

handle remainder => sub {
    return if $_;
    return "enricofoltran is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
