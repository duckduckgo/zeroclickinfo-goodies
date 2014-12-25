package DDG::Goodie::IsAwesome::ymzong;
# ABSTRACT: ymzong's first Goodie!

use DDG::Goodie;

zci answer_type => "is_awesome_ymzong";
zci is_cached   => 1;

name "IsAwesome ymzong";
description "My first Goodie, it let's the world know that ymzong is awesome!!";
primary_example_queries "duckduckhack ymzong";
category "special";
topics "special_interest", "geek", "math", "programming";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/ymzong.pm";
attribution github => "ymzong";

triggers start => "duckduckhack ymzong";

handle remainder => sub {

    return if $_;
    return "ymzong is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
    
};

1;
