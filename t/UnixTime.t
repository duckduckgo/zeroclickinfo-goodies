#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'time_conversion';
zci is_cached   => 0;

my $zero_re = qr/0 \(Unix time\):.+Thu Jan 01 00:00:00 1970 UTC/;
my $now_re  = qr/\d+ \(Unix time\):.+UTC/;

ddg_goodie_test([qw(
          DDG::Goodie::UnixTime
          )
    ],
    'unix time 0000000000000' => test_zci($zero_re),
    'epoch 0'                 => test_zci($zero_re),
    'epoch 2147483647'        => test_zci(qr/2147483647 \(Unix time\):.+Tue Jan 19 03:14:07 2038 UTC/),
    'timestamp 2147483647'    => test_zci(qr/2147483647 \(Unix time\):.+Tue Jan 19 03:14:07 2038 UTC/),
    'datetime'                => test_zci($now_re),
    'unix time'               => test_zci($now_re),
    'unix epoch'              => test_zci($now_re),
    'timestamp'               => undef,
    'time'                    => undef,
    'epoch'                   => undef,
);

done_testing;
