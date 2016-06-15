#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'tip';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Tips)],
    '20% tip on $20'                  => test_zci('Tip: $4.00; Total: $24.00'),
    '20% tip on $20 bill'             => test_zci('Tip: $4.00; Total: $24.00'),
    '20% tip for a $20 bill'          => test_zci('Tip: $4.00; Total: $24.00'),
    '20 percent tip on $20'           => test_zci('Tip: $4.00; Total: $24.00'),
    '20% tip on $21.63'               => test_zci('Tip: $4.33; Total: $25.96'),
    '20 percent tip for a $20 bill'   => test_zci('Tip: $4.00; Total: $24.00'),
    '20 percent tip for a $2000 bill' => test_zci('Tip: $400.00; Total: $2,400.00'),
    '2% of $25,000'                   => test_zci('$500.00 is 2 percent of $25,000.00'),
    'best of 5'                       => undef,
    '4 of 5 dentists'                 => undef,
);

done_testing;
