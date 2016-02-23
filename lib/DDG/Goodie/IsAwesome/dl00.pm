package DDG::Goodie::IsAwesome::dl00;
# ABSTRACT: dl00's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_dl00";
zci is_cached   => 1;

triggers start => "duckduckhack dl00";

handle remainder => sub {
    return if $_;
    return "dl00 is awesome and successfully completed the initiation tutorial for DuckDuckHack."
};

1;
