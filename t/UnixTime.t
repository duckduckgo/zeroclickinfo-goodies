#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'time_conversion';
zci is_cached   => 0;

my @zero  = (qr/0 \(Unix epoch\):.+Thu Jan 01 00:00:00 1970 UTC/,          html => qr/Thu Jan 01 00:00:00 1970 UTC/);
my @now   = (qr/\d+ \(Unix epoch\):.+UTC/,                                 html => qr/UTC/);
my @later = (qr/2147483647 \(Unix epoch\):.+Tue Jan 19 03:14:07 2038 UTC/, html => qr/Tue Jan 19 03:14:07 2038 UTC/);

ddg_goodie_test([qw(
          DDG::Goodie::UnixTime
          )
    ],
    'unix time 0000000000000' => test_zci(@zero),
    'epoch 0'                 => test_zci(@zero),
    'epoch 2147483647'        => test_zci(@later),
    'timestamp 2147483647'    => test_zci(@later),
    'datetime'                => test_zci(@now),
    'unix time'               => test_zci(@now),
    'unix epoch'              => test_zci(@now),
    'timestamp'               => undef,
    'time'                    => undef,
    'epoch'                   => undef,
);

done_testing;
