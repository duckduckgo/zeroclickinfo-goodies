#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'and';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
DDG::Goodie::And
)],
        '4 and 5' => test_zci('4'),
        '0 et 1' => test_zci('0'),
        '5 ⊕ 79' => test_zci('5'),
        '7607 and 13444 and 5831 and 11077' => test_zci('4')
);

done_testing;
