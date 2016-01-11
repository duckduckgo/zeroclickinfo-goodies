package DDG::Goodie::IsAwesome::stefolof;
# ABSTRACT: stefolof's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_stefolof";
zci is_cached   => 1;

triggers start => "duckduckhack stefolof";

handle remainder => sub {
    return if $_;
    return "stefolof is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";

};

1;
