package DDG::Goodie::IsAwesome::kefkius;
# ABSTRACT: kefkius' first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_kefkius";
zci is_cached   => 1;

name "IsAwesome kefkius";
description "My first Goodie, it lets the world know that kefkius is awesome and that he says hello";
primary_example_queries "duckduckhack kefkius";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/kefkius.pm";
attribution github => ["https://github.com/kefkius", "kefkius"],
            twitter => "kefkius";

triggers start => "duckduckhack kefkius";

handle remainder => sub {
    return if $_;
    return "kefkius is awesome, hello world!";
};

1;
