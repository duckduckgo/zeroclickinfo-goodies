package DDG::Goodie::IsAwesome::zekiel;
# ABSTRACT: A simple goodie by zekiel

use DDG::Goodie;

zci answer_type => "is_awesome_zekiel";
zci is_cached   => 1;

name "IsAwesome zekiel";
description "Describes who exactly is awesome and all of his/her many accomplishment.";
primary_example_queries "duckduckhack zekiel";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/zekiel.pm";
attribution github => ["https://github.com/zekiel", "zekiel"],
            twitter => "zacpappis";


triggers start => "duckduckhack zekiel", "zekiel duckduckhack";

handle remainder => sub {
    return if $_;
    return "zekiel is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;