#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'time_conversion';
zci is_cached   => 0;

my @zero  = (qr/Thu Jan 01 00:00:00 1970 UTC/, html => qr/Thu Jan 01 00:00:00 1970 UTC/);
my @now   = (qr/Unix Epoch.+UTC/,              html => qr/UTC/);
my @then  = (qr/Tue Nov 18 00:28:30 1930 UTC/, html => qr/Tue Nov 18 00:28:30 1930 UTC/);
my @later = (qr/Tue Jan 19 03:14:07 2038 UTC/, html => qr/Tue Jan 19 03:14:07 2038 UTC/);

ddg_goodie_test([qw(
          DDG::Goodie::UnixTime
          )
    ],
    'unix time 0000000000000' => test_zci(@zero),
    'epoch 0'                 => test_zci(@zero),
    'utc time 0'              => test_zci(@zero),
    'epoch 2147483647'        => test_zci(@later),
    '2147483647 epoch'        => test_zci(@later),
    'timestamp 2147483647'    => test_zci(@later),
    'utc time 2147483647'     => test_zci(@later),
    'datetime'                => test_zci(@now),
    'unix time'               => test_zci(@now),
    'unix epoch'              => test_zci(@now),
    'utc time'                => test_zci(@now),
    'utc now'                 => test_zci(@now),
    'current utc'             => test_zci(@now),
    'epoch -1234567890'       => test_zci(@then),
    '-1234567890 epoch'       => test_zci(@then),
    'timestamp -1234567890'   => test_zci(@then),
    'utc time -1234567890'    => test_zci(@then),
    'timestamp'               => undef,
    'time'                    => undef,
    'epoch'                   => undef,
);

done_testing;
