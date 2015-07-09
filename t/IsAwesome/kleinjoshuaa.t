#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_kleinjoshuaa";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::kleinjoshuaa )],
    'duckduckhack kleinjoshuaa' => test_zci('kleinjoshuaa is awesome and has successfully completed the duckduckhack goodie tutorial!'),
    'duckduckhack kleinjoshuaa is awesome' => undef,

);

done_testing;
