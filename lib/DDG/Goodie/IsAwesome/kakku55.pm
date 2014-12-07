package DDG::Goodie::IsAwesome::kakku55;
# ABSTRACT: kakku55's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_kakku55";
zci is_cached   => 1;

name "IsAwesome kakku55";
description "My first Goodie, it let's the world know that kakku55 is awesome";
primary_example_queries "duckduckhack kakku55";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/kakku55.pm";
attribution github => ["https://github.com/kakku55", "kakku55"],
            twitter => "alipsanen";

triggers start => "duckduckhack kakku55";

handle remainder => sub {
    return if $_;
    return "kakku55 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
