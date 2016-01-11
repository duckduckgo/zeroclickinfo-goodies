package DDG::Goodie::IsAwesome::sonny7;
# ABSTRACT: sonny7's firstGoodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_sonny7";
zci is_cached   => 1;

triggers start => "duckduckhack sonny7";

handle remainder => sub {
    return if $_;
    return "sonny7 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
