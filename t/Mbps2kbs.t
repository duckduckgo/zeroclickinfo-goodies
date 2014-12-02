#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "mbps2kbs";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Mbps2kbs )],
    '5 mbps in kb/s' => test_zci('5 Mbps = 625 kilobytes / second'),
    'bad example query' => undef,
);

done_testing;
