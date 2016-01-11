package DDG::Goodie::IsAwesome::MaxPower9;
# ABSTRACT: MaxPower9's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_max_power9";
zci is_cached   => 1;

triggers start => "duckduckhack maxpower9";

handle remainder => sub {

    return if $_;
    
    return "MaxPower9 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
