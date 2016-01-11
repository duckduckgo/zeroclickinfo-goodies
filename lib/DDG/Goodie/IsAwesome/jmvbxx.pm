package DDG::Goodie::IsAwesome::jmvbxx;
# ABSTRACT: jmvbxx's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_jmvbxx";
zci is_cached   => 1;

triggers start => "duckduckhack jmvbxx";

handle remainder => sub {
    return if $_;
    return "jmvbxx is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
