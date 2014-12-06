package DDG::Goodie::IsAwesome::zekiel;
# ABSTRACT: thejdeep's first Goodie !

use DDG::Goodie;

zci answer_type => "is_awesome_zekiel";
zci is_cached   => 1;

name "IsAwesome zekiel";
description "My semi-first Goodie proving I too can build instant answers.";
primary_example_queries "duckduckhack zekiel";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/zekiel.pm";
attribution github => ["https://github.com/zekiel", "zekiel"],
            twitter => "zacpappis";


triggers start => "duckduckhack zekiel";

handle remainder => sub {
    return if $_;
    return "zekiel is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;