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
'120 BPM as quarter notes per minute
Whole Note: 2000 ms, Triplet: 1333 ms, Dotted: 3000 ms
Half Note: 1000 ms, Triplet: 667 ms, Dotted: 1500 ms
Quarter Note: 500 ms, Triplet: 333 ms, Dotted: 750 ms
1/8 Note: 250 ms, Triplet: 167 ms, Dotted: 375 ms
1/16 Note: 125 ms, Triplet: 83 ms, Dotted: 188 ms
1/32 Note: 63 ms, Triplet: 42 ms, Dotted: 94 ms
1/64 Note: 31 ms, Triplet: 21 ms, Dotted: 47 ms',                                                                                                                                                                                 
    html => qr#.*#
)) } ( '120 bpm to ms', '120 beats per minute to note lengths', '120 bpm timings' ),
);                                        

done_testing;
