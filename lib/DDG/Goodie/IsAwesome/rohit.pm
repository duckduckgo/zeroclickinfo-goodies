package DDG::Goodie::IsAwesome::rohit;
# ABSTRACT: A simple goodie by rohit

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_rohit";
zci is_cached   => 1;

name "IsAwesome rohit";
description "Describes who exactly is awesome and all of his/her many accomplishment.";
primary_example_queries "duckduckhack rohit";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/rohit.pm";
attribution github => ["https://github.com/rohitzidu", "rohit"],
            twitter => "rohitzedu";


triggers start => "duckduckhack rohit", "rohit duckduckhack";

handle remainder => sub {
    return if $_;
    return "rohit is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;