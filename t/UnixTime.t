#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'time_conversion';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::UnixTime
	)],
    'unix time 0000000000000' => test_zci('Unix Time Conversion: Thu Jan 01 00:00:00 1970 +0000'),
    'epoch 0' => test_zci('Unix Time Conversion: Thu Jan 01 00:00:00 1970 +0000'),
    'epoch 2147483647' => test_zci('Unix Time Conversion: Tue Jan 19 03:14:07 2038 +0000'),
    map {
        "$_ 0" => test_zci('Unix Time Conversion: Thu Jan 01 00:00:00 1970 +0000'),
    }, [ 'unixtime', 'time', 'timestamp', 'datetime', 'epoch', 'unix time', 'unix timestamp', 'unix epoch' ]
);

done_testing;
