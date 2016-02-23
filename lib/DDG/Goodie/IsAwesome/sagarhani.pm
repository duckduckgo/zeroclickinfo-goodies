package DDG::Goodie::IsAwesome::sagarhani;
#ABSTRACT: sagarhani's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_sagarhani";
zci is_cached   => 1;

triggers start => "duckduckhack sagarhani";

handle remainder => sub {
    return if $_;
    return "sagarhani is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
