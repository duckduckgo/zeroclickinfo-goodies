#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'excel';
zci is_cached  => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Excel )],
    'excel sum' => test_zci('SUM function: Adds its arguments')
);

done_testing;
