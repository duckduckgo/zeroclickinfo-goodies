#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => 'frequency';

ddg_goodie_test(
        [qw(
                DDG::Goodie::Frequency
        )],
    'frequency of all in test' => test_zci('FREQUENCY: e:1/4 s:1/4 t:2/4'),
    'frequency of all in testing 1234 ABC!' => test_zci('FREQUENCY: a:1/10 b:1/10 c:1/10 e:1/10 g:1/10 i:1/10 n:1/10 s:1/10 t:2/10'),
    'frequency of all in Assassins!' => test_zci('FREQUENCY: a:2/9 i:1/9 n:1/9 s:5/9'),
    'frequency of a in Atlantic Ocean' => test_zci('FREQUENCY: a:3/13'),
    'freq of B in battle' => test_zci('FREQUENCY: b:1/6'),
    'freq of s in Spoons' => test_zci('FREQUENCY: s:2/6'),

);

done_testing;
