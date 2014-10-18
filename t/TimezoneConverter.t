#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'timezone_converter';
zci is_cached => 1;

ddg_goodie_test(
    ['DDG::Goodie::TimezoneConverter'],
    '3:14 in GMT' =>
        test_zci('3:14 (UTC) is 3:14 (GMT).', 
            html => qr/.*3:14.*\(UTC\) is.*3:14.*\(GMT\)./
        ),
    '8:10 A.M. AZOST into CAT' =>
        test_zci('8:10 A.M. (AZOST, UTC-1) is 11:10 A.M. (CAT, UTC+2).',
            html => qr/./
        ),
    '1pm EDT into UTC+2' =>
        test_zci('1:00 P.M. (EDT, UTC-4) is 7:00 P.M. (UTC+2).',
            html => qr/./
        ),
    '0pm into GMT' =>
        test_zci('Noon (UTC) is noon (GMT).',
            html => qr/./
        ),
    '0am into UTC' =>
        test_zci('Midnight (UTC) is midnight (UTC).',
            html => qr/./
        ),
    '1 into UTC -2 ' =>
        test_zci('1:00 (UTC) is 23:00, 1 day prior (UTC-2).',
            html => qr/./
        ),
    ' 1 into UTC-1' =>
        test_zci('1:00 (UTC) is 0:00 (UTC-1).',
            html => qr/./
        ),
    '21 FNT into EET' =>
        test_zci('21:00 (FNT, UTC-2) is 1:00, 1 day after (EET, UTC+2).',
            html => qr/./
    ),
    '23:00:00  InTo  UTC+1' =>
        test_zci('23:00 (UTC) is 0:00, 1 day after (UTC+1).',
            html => qr/./
    ),
    '23:00:01  Into    UTC+1' =>
        test_zci('23:00:01 (UTC) is 0:00:01, 1 day after (UTC+1).',
            html => qr/./
    ),
    '13:15:00 UTC-0:30 into UTC+0:30' =>
        test_zci('13:15 (UTC-0:30) is 13:15 (UTC+0:30).',
            html => qr/./
    ),
    # ok, this is unlikely to happen without trying to do that
    '19:42:42 BIT into GMT+100' =>
        test_zci('19:42:42 (BIT, UTC-12) is 11:42:42, 5 days after (GMT+100).',
            html => qr/./
    ),
    '19:42:42 CHADT into GMT-100' =>
        test_zci('19:42:42 (CHADT, UTC+13:45) is 1:57:42, 4 days prior (GMT-100).',
        html => qr/./
    ),
    '12 in binary' => undef,
    '10:00AM MST to PST' => 
        test_zci('10:00 A.M. (MST, UTC-7) is 9:00 A.M. (PST, UTC-8).',
        html => qr/./
    ),
    '19:00 UTC to EST' => 
        test_zci('19:00 (UTC) is 14:00 (EST, UTC-5).',
        html => qr/./
    ),
    '1am UTC to PST' => 
        test_zci('1:00 A.M. (UTC) is 5:00 P.M., 1 day prior (PST, UTC-8).',
        html => qr/./
    ),
    '12:40pm PST into JST' =>
        test_zci('12:40 P.M. (PST, UTC-8) is 5:40 A.M., 1 day after (JST, UTC+9).',
        html => qr/./
    ),
    '12:40 pm from PST to JST' =>
        test_zci('12:40 P.M. (PST, UTC-8) is 5:40 A.M., 1 day after (JST, UTC+9).',
        html => qr/.*12:40 P.M..*\(PST, UTC-8\) is.*5:40 A.M., 1 day after.*\(JST, UTC\+9\)./
    ),
    '11:22am est in utc' =>
        test_zci('11:22 A.M. (EST, UTC-5) is 4:22 P.M. (UTC).',
        html => qr/.*11:22 A.M..*\(EST, UTC-5\) is.*4:22 P.M..*\(UTC\)./
    ),
);

done_testing;
