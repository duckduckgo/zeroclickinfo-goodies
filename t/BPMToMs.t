#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "bpmto_ms";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::BPMToMs )],                                                                                                                                                       
    map { ("$_" => test_zci(
'Whole Note: 2000 ms, Triplet: 1333.33333333333 ms, Dotted: 3000 ms
Half Note: 1000 ms, Triplet: 666.666666666667 ms, Dotted: 1500 ms
Quarter Note: 500 ms, Triplet: 333.333333333333 ms, Dotted: 750 ms
1/8 Note: 250 ms, Triplet: 166.666666666667 ms, Dotted: 375 ms
1/16 Note: 125 ms, Triplet: 83.3333333333333 ms, Dotted: 187.5 ms
1/32 Note: 62.5 ms, Triplet: 41.6666666666667 ms, Dotted: 93.75 ms
1/64 Note: 31.25 ms, Triplet: 20.8333333333333 ms, Dotted: 46.875 ms',                                                                                                                                                                                 
    html => qr#.*#
)) } ( '120 bpm to ms' ),
);                                        

done_testing;
