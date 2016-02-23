package DDG::Goodie::IsAwesome::mtoledo;
# ABSTRACT: mtoledo's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_mtoledo";
zci is_cached   => 1;

triggers start => "duckduckhack mtoledo";

handle remainder => sub {
    return if $_;
    return "mtoledo has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
