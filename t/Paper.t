#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'paper';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::Paper
    )],
    'a0 paper size' => test_zci('841mm x 1189mm  (33.11in x 46.81in)'),
    'c10 paper dimension' => test_zci('28mm x 40mm  (1.10in x 1.57in)'),
    'b10 paper dimensions' => test_zci('31mm x 44mm  (1.22in x 1.73in)'),
    'letter paper size' => test_zci('210mm x 279mm  (8.27in x 11in)'),
    'legal paper dimensions' => test_zci('216mm x 356mm  (8.5in x 14in)'),
    'junior legal paper dimensions' => test_zci('203mm x 127mm  (8in x 5in)'),
    'ledger paper dimensions' => test_zci('432mm x 279mm  (17in x 11in)'),
    'tabloid paper size' => test_zci('279mm x 432mm  (11in x 17in)'),
);

done_testing;
