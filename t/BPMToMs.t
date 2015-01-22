#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "bpmto_ms";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::BPMToMs)],
    (map { ("$_" => test_zci(
'120 bpm in milliseconds
Whole Note: 2000, Triplet: 1333, Dotted: 3000
Half Note: 1000, Triplet: 667, Dotted: 1500
Quarter Note: 500, Triplet: 333, Dotted: 750
1/8 Note: 250, Triplet: 167, Dotted: 375
1/16 Note: 125, Triplet: 83, Dotted: 188
1/32 Note: 63, Triplet: 42, Dotted: 94',
    html => qr#<td class="record__cell__key record_keyspacing">Whole Note</td><td class="record__cell__value numbers">2000</td>#
)) } ( '120 bpm to ms', '120 beats per minute to note lengths', '120 bpm timings' )),
    (map { ("$_" => test_zci(
'61 bpm in milliseconds
Whole Note: 3934, Triplet: 2623, Dotted: 5902
Half Note: 1967, Triplet: 1311, Dotted: 2951
Quarter Note: 984, Triplet: 656, Dotted: 1475
1/8 Note: 492, Triplet: 328, Dotted: 738
1/16 Note: 246, Triplet: 164, Dotted: 369
1/32 Note: 123, Triplet: 82, Dotted: 184',
    html => qr#<td class="record__cell__key record_keyspacing">Whole Note</td><td class="record__cell__value numbers">3934</td>#
)) } ( '61 beats per minute to ms', '61 bpm', '61 bpm to note values' )),
    '-1 bpm to ms' => undef,
    'some bpm to ms' => undef,
    'bpm' => undef,
);

done_testing;
