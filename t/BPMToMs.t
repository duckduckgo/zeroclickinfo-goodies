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
Whole Note: 2000
Half Note: 1000
Quarter Note: 500
1/8 Note: 250
1/16 Note: 125
1/32 Note: 63',
    html => qr#<td class="record__cell__key record_keyspacing">Whole Note</td><td class="record__cell__value numbers">2000</td>#
)) } ( '120 bpm to ms', '120 beats per minute to note lengths', '120 bpm timings' )),
    (map { ("$_" => test_zci(
'61 bpm in milliseconds
Whole Note: 3934
Half Note: 1967
Quarter Note: 984
1/8 Note: 492
1/16 Note: 246
1/32 Note: 123',
    html => qr#<td class="record__cell__key record_keyspacing">Whole Note</td><td class="record__cell__value numbers">3934</td>#
)) } ( '61 beats per minute to ms', '61 bpm', '61 bpm to note values' )),
    '-1 bpm to ms' => undef,
    'some bpm to ms' => undef,
    'bpm' => undef,
);

done_testing;
