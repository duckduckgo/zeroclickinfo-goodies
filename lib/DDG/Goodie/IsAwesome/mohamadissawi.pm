package DDG::Goodie::IsAwesome::mohamadissawi;
# ABSTRACT: mohamadissawi's first goodie

use DDG::Goodie;

zci answer_type => "is_awesome_mohamadissawi";
zci is_cached   => 1;


name "IsAwesome mohamadissawi";
description "My first Goodie, it let's the world know that mohamadissawi is awesome";
primary_example_queries "duckduckhack mohamadissawi";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/mohamadissawi.pm";
attribution github => ["https://github.com/mohamadissawi", "mohamadissawi"],



triggers start => "duckduckhack mohamadissawi";


handle remainder => sub {
    return if $_;
    return "mohamadissawi is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;
