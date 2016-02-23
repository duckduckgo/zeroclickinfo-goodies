package DDG::Goodie::IsAwesome::aarohmankad;
# ABSTRACT: aarohmankad's first goodie for DuckDuckGo

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_aarohmankad";
zci is_cached   => 1;

triggers start => "duckduckhack aarohmankad";

handle remainder => sub {
    return if $_;
    return "aarohmankad is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
