package DDG::Goodie::IsAwesome::jee1mr;
#ABSTRACT: jee1mr's first Goodie


use DDG::Goodie;

zci answer_type => "is_awesome_jee1mr";
zci is_cached   => 1;


name "IsAwesome jee1mr";
description "My first Goodie, it let's the world know that jee1mr is awesome";
primary_example_queries "duckduckhack jee1mr";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/jee1mr.pm";
attribution github => ["https://github.com/jee1mr", "jee1mr"],
            web     => ['http://jeevanmr.com', 'Jeevan M R'],
            twitter => "jee1mr";


triggers start => "duckduckhack jee1mr";


handle remainder => sub {
    return if $_;
    return "jee1mr is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
