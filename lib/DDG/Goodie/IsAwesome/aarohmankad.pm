package DDG::Goodie::IsAwesome::aarohmankad;
# ABSTRACT: aarohmankad's first goodie for DuckDuckGo

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_aarohmankad";
zci is_cached   => 1;

name "IsAwesome aarohmankad";
description "My first goodie, it lets the world know aarohmankad is awesome";
primary_example_queries "duckduckhack aarohmankad";

category "special";

topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/aarohmankad.pm";
attribution github => ["http://www.github.com/aarohmankad", "Aaroh Mankad"],
            twitter => "aarohmankad";


triggers start => "duckduckhack aarohmankad";


handle remainder => sub {
    return if $_;
    return "aarohmankad is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
