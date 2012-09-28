#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'timezone_converter';
zci is_cached => 1;

ddg_goodie_test(
    ['DDG::Goodie::TimezoneConverter'],
    '3:14 into GMT' =>
        test_zci('3:14 (UTC) is 3:14 (GMT).'),
    '8:10 A.M. AZOST into CAT' =>
        test_zci('8:10 (AZOST, UTC-1) is 11:10 (CAT, UTC+2).'),
    '1pm EDT into UTC+2' =>
        test_zci('13:00 (EDT, UTC-4) is 19:00 (UTC+2).'),
    '1 into UTC -2 ' =>
        test_zci('1:00 (UTC) is 23:00, 1 day prior (UTC-2).'),
    ' 1 into UTC-1' =>
        test_zci('1:00 (UTC) is 0:00 (UTC-1).'),
    '21 FNT into EET' =>
        test_zci('21:00 (FNT, UTC-2) is 1:00, 1 day after (EET, UTC+2).'),
    '23:00:00  InTo  UTC+1' =>
        test_zci('23:00 (UTC) is 0:00, 1 day after (UTC+1).'),
    '23:00:01  Into    UTC+1' =>
        test_zci('23:00:01 (UTC) is 0:00:01, 1 day after (UTC+1).'),
    '13:15:00 UTC-0:30 into UTC+0:30' =>
        test_zci('13:15 (UTC-0:30) is 13:15 (UTC+0:30).'),
    # ok, this is unlikely to happen without trying to do that
    '19:42:42 BIT into GMT+100' =>
        test_zci('19:42:42 (BIT, UTC-12) is 11:42:42, 5 days after (GMT+100).'),
    '19:42:42 CHADT into GMT-100' =>
        test_zci('19:42:42 (CHADT, UTC+13:45) is 1:57:42, 4 days prior (GMT-100).'),   
);

done_testing;
