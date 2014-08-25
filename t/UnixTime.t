#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'time_conversion';
zci is_cached => 0;

ddg_goodie_test([qw(
          DDG::Goodie::UnixTime
          )
    ],
    'unix time 0000000000000' => test_zci('Unix Time: Thu Jan 01 00:00:00 1970 +0000'),
    'epoch 0'                 => test_zci('Unix Time: Thu Jan 01 00:00:00 1970 +0000'),
    'epoch 2147483647'        => test_zci('Unix Time: Tue Jan 19 03:14:07 2038 +0000'),
    #'epoch'                   => test_zci(qr/Unix Time: [^\+]+\+0000/),                    # Now in UTC.
    #'timestamp'               => test_zci(qr/Unix Time: [^\+]+\+0000/),                    # Now in UTC.
    #'datetime'                => test_zci(qr/Unix Time: [^\+]+\+0000/),                    # Now in UTC.
);

done_testing;
