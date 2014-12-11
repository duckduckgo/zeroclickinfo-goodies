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
    'Dax the Duck' => test_zci('You know, I am on the front page!'),
    
);

done_testing;
