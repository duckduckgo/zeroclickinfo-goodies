package DDG::Goodie::IsAwesome::isleofmax;
# ABSTRACT: isleofmax's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_isleofmax";
zci is_cached   => 1;

triggers start => "duckduckhack isleofmax";

handle remainder => sub {
    return if $_;
    return "isleofmax is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
