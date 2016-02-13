package DDG::Goodie::IsAwesome::chercolvin;
# ABSTRACT: chercolvin's first goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_chercolvin";
zci is_cached   => 1;

triggers start => "duckduckhack chercolvin";

handle remainder => sub {

    return if $_;
    return "chercolvin is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
    
};

1;
