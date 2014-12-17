#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "dax_the_duck";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::DaxTheDuck
    )],
    'Dax the Duck' => test_zci("Dax is DuckDuckGo's mascot. Check him out in the top left corner or at the homepage!"),
    'who is dax the duck'=> test_zci("Dax is DuckDuckGo's mascot. Check him out in the top left corner or at the homepage!"),
    'who is dax'=> test_zci("Dax is DuckDuckGo's mascot. Check him out in the top left corner or at the homepage!"),
    'where is dax the duck'=> test_zci("Dax is DuckDuckGo's mascot. Check him out in the top left corner or at the homepage!"),
    
    
);

done_testing;
