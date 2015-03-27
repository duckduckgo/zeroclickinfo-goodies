#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_it_christmas";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsItChristmas )],
    'isitchristmas' => test_zci('(Yes|No)'),
    'is it christmas' => test_zci('(Yes|No)'),
    'christmas' => undef,
);

done_testing;
