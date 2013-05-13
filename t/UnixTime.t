#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'time_conversion';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::UnixTime
	)],
    map {
        "$_ 0" => test_zci('Unix Time Conversion: Thu Jan 01 00:00:00 1970 +0000'),
    }, [ 'unixtime', 'time', 'timestamp', 'datetime', 'epoch', 'unix time', 'unix epoch' ]
);

done_testing;
