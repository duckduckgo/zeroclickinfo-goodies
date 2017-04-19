#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'or';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
DDG::Goodie::Or
)],
        '9 or 5' => test_zci('13'),
        '5 ∨ 59' => test_zci('63'),
        '86 or 8209 or 4293 or 4129' => test_zci('12535')
);

done_testing;
