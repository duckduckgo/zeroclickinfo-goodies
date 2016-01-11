package DDG::Goodie::IsAwesome::DeanT765;
# ABSTRACT: DeanT765's first Goodie 

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_dean_t765";
zci is_cached   => 1;

triggers start => "duckduckhack deant765";

handle remainder => sub {
    return if $_;
    return "DeanT765 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
