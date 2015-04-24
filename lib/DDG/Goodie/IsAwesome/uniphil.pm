package DDG::Goodie::IsAwesome::uniphil;
# ABSTRACT: uniphil's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_uniphil";
zci is_cached   => 1;

name "IsAwesome uniphil";
description "My first Goodie, like so many before, in hopes of having a search engine tell me I'm awesome";
primary_example_queries "duckduckhack uniphil";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/uniphil.pm";
attribution github => ["https://github.com/uniphil", "uniphil"],
            twitter => "unicyclephil";

triggers start => "duckduckhack uniphil";

handle remainder => sub {
    return if $_;
    return "uniphil is awesome I guess. They successfully completed the DuckDuckHack Goodie tutorial anyway."
};

1;
