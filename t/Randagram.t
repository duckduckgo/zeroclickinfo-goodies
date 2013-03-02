#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'randagram';
zci is_cached => 0;

ddg_goodie_test(
    [qw(DDG::Goodie::Randagram)],
    'randagram algorithm' => test_zci(qr/Randagram: [algorithm]/)
    );

done_testing;
