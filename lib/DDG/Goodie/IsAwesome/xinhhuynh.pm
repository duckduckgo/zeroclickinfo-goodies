package DDG::Goodie::IsAwesome::xinhhuynh;
# ABSTRACT: xinhhuynh's first goodie.

use DDG::Goodie;

zci answer_type => "is_awesome_xinhhuynh";
zci is_cached   => 1;

name "IsAwesome xinhhuynh";
description "My first goodie, it lets the world know that xinhhuynh is awesome.";
primary_example_queries "duckduckhack xinhhuynh";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/xinhhuynh.pm";
attribution github => ["https://github.com/xinhhuynh", "Xinh Huynh"],
            twitter => "xinh_huynh";

triggers start => "duckduckhack xinhhuynh";

handle remainder => sub {

    return if $_;
    return "xinhhuynh is awesome and has successfully completed the tutorial!"; # Guard against "no answer"
};

1;
