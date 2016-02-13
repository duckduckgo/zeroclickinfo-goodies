package DDG::Goodie::IsAwesome::marcantonio;
# ABSTRACT: marcantonio's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_marcantonio";
zci is_cached   => 1;

triggers start => "duckduckhack marcantonio";

handle remainder => sub {
    return if $_;
    return "marcantonio is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
