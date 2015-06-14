#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "andaz_apna_apna";
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::AndazApnaApna )],
    # Ensure that a quote is returned for the primary and secondary queries
    'andazapnaapna' => test_zci (qr/\w/),
    'andaz apna apna' => test_zci (qr/\w/),
    'andaz apna apna quotes' => test_zci(qr/\w/),
    'movie quotes' => undef,
);

done_testing;
