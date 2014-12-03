#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "indian_rail_pnrstatus";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IndianRailPNRStatus )],
    'pnr 4101917424' => test_zci('Status: CNF'),
    'pnr 123' => undef,
    'pnr 1234567890' => undef,
);

done_testing;
