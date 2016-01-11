package DDG::Goodie::IsAwesome::aweiksnar;
# ABSTRACT: aweiksnar's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_aweiksnar";
zci is_cached   => 1;

triggers start => "duckduckhack aweiksnar";

handle remainder => sub {
    return if $_;
    return "aweiksnar is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
