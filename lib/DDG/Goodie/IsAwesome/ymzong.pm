package DDG::Goodie::IsAwesome::ymzong;
# ABSTRACT: ymzong's first Goodie!

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_ymzong";
zci is_cached   => 1;

triggers start => "duckduckhack ymzong";

handle remainder => sub {

    return if $_;
    return "ymzong is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
    
};

1;
