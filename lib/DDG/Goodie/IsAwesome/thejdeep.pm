package DDG::Goodie::IsAwesome::thejdeep;
# ABSTRACT: thejdeep's first Goodie !

use DDG::Goodie;

zci answer_type => "is_awesome_thejdeep";
zci is_cached   => 1;

name "IsAwesome thejdeep";
description "My first Goodie, it let's the world know that thejdeep is awesome";
primary_example_queries "duckduckhack thejdeep";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/thejdeep.pm";
attribution github => ["https://github.com/thejdeep", "thejdeep"],
            twitter => "thejdeep";

triggers start => "duckduckhack thejdeep";

handle remainder => sub {
    return if $_;
    return "thejdeep is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
