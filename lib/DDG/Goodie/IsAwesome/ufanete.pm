package DDG::Goodie::IsAwesome::ufanete;
# ABSTRACT: ufanete's first Goodie

use strict;
use DDG::Goodie;

zci answer_type => "is_awesome_ufanete";
zci is_cached   => 1;

triggers start => "duckduckhack ufanete";

handle remainder => sub {

    return if $_;
    return "ufanete is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};



1;
