#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

zci answer_type => 'timezone_converter';
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::TimezoneConverter'],
    '3:14 in GMT' =>
        test_zci('3:14 (UTC) is 3:14 (GMT).',
            html => qr/.*3:14.*\(UTC\) is.*3:14.*\(GMT\)./
        ),
    '8:10 AM AZOST into CAT' =>
        test_zci('8:10 AM (AZOST, UTC-1) is 11:10 AM (CAT, UTC+2).',
        html => '-ANY-'
        ),
    '1pm EDT into UTC+2' =>
        test_zci('1:00 PM (EDT, UTC-4) is 7:00 PM (UTC+2).',
        html => '-ANY-'
        ),
    '0pm into GMT' =>
        test_zci('Noon (UTC) is noon (GMT).',
        html => '-ANY-'
        ),
    '0am into UTC' =>
        test_zci('Midnight (UTC) is midnight (UTC).',
        html => '-ANY-'
        ),
    '1 into UTC -2 ' =>
        test_zci('1:00 (UTC) is 23:00, 1 day prior (UTC-2).',
        html => '-ANY-'
        ),
    ' 1 into UTC-1' =>
        test_zci('1:00 (UTC) is 0:00 (UTC-1).',
        html => '-ANY-'
        ),
    '21 FNT into EET' =>
        test_zci('21:00 (FNT, UTC-2) is 1:00, 1 day after (EET, UTC+2).',
        html => '-ANY-'
    ),
    '23:00:00  InTo  UTC+1' =>
        test_zci('23:00 (UTC) is 0:00, 1 day after (UTC+1).',
        html => '-ANY-'
    ),
    '23:00:01  Into    UTC+1' =>
        test_zci('23:00:01 (UTC) is 0:00:01, 1 day after (UTC+1).',
        html => '-ANY-'
    ),
    '13:15:00 UTC-0:30 into UTC+0:30' =>
        test_zci('13:15 (UTC-0:30) is 13:15 (UTC+0:30).',
        html => '-ANY-'
    ),
    # ok, this is unlikely to happen without trying to do that
    '19:42:42 BIT into GMT+100' =>
        test_zci('19:42:42 (BIT, UTC-12) is 11:42:42, 5 days after (GMT+100).',
        html => '-ANY-'
    ),
    '19:42:42 CHADT into GMT-100' =>
        test_zci('19:42:42 (CHADT, UTC+13:45) is 1:57:42, 4 days prior (GMT-100).',
        html => '-ANY-'
    ),
    '10:00AM MST to PST' =>
        test_zci('10:00 AM (MST, UTC-7) is 9:00 AM (PST, UTC-8).',
        html => '-ANY-'
    ),
    '19:00 UTC to EST' =>
        test_zci('19:00 (UTC) is 14:00 (EST, UTC-5).',
        html => '-ANY-'
    ),
    '1am UTC to PST' =>
        test_zci('1:00 AM (UTC) is 5:00 PM, 1 day prior (PST, UTC-8).',
        html => '-ANY-'
    ),
    '12:40pm PST into JST' =>
        test_zci('12:40 PM (PST, UTC-8) is 5:40 AM, 1 day after (JST, UTC+9).',
        html => '-ANY-'
    ),
    '12:40 pm from PST to JST' =>
        test_zci('12:40 PM (PST, UTC-8) is 5:40 AM, 1 day after (JST, UTC+9).',
        html => qr/.*12:40 PM.*\(PST, UTC-8\) is.*5:40 AM, 1 day after.*\(JST, UTC\+9\)./
    ),
    '11:22am est in utc' =>
        test_zci('11:22 AM (EST, UTC-5) is 4:22 PM (UTC).',
        html => qr/.*11:22 AM.*\(EST, UTC-5\) is.*4:22 PM.*\(UTC\)./
    ),
    # Intentional non-answers
    '12 in binary' => undef,
);

# Summertime
my $test_location_tz = qr/\(EDT, UTC-4\)/;
set_fixed_time("2014-10-14T00:00:00");
ddg_goodie_test(
    ['DDG::Goodie::TimezoneConverter'],
    # Location-specific tests (variable with DST)
    '13:00 GMT in my time' =>
        test_zci(qr/13:00 \(GMT\) is 9:00 $test_location_tz/,
        html => '-ANY-'
    ),
    '11:22am cest in my timezone' =>
        test_zci(qr/11:22 AM \(CEST, UTC\+2\) is 5:22 AM $test_location_tz/,
        html => '-ANY-'
    ),
    '11:22am cest in localtime' =>
        test_zci(qr/11:22 AM \(CEST, UTC\+2\) is 5:22 AM $test_location_tz/,
        html => '-ANY-'
    ),
    '11:22am cest in my local timezone' =>
        test_zci(qr/11:22 AM \(CEST, UTC\+2\) is 5:22 AM $test_location_tz/,
        html => '-ANY-'
    ),
    '12pm my time in CEST' =>
        test_zci(qr/Noon $test_location_tz is 6:00 PM \(CEST, UTC\+2\)./,
        html => '-ANY-'
    ),
    '12pm local timezone in CEST' =>
        test_zci(qr/Noon $test_location_tz is 6:00 PM \(CEST, UTC\+2\)./,
        html => '-ANY-'
    ),
    '12am my timezone in UTC' =>
        test_zci(qr/Midnight $test_location_tz is 4:00 AM \(UTC\)./,
        html => '-ANY-'
    ),
    '12am local time in UTC' =>
        test_zci(qr/Midnight $test_location_tz is 4:00 AM \(UTC\)./,
        html => '-ANY-'
    ),
);
restore_time();

set_fixed_time("2014-11-02T11:00:00");
$test_location_tz = qr/\(EST, UTC-5\)/;
ddg_goodie_test(
    ['DDG::Goodie::TimezoneConverter'],
    # Location-specific tests (variable with DST)
    '13:00 GMT in my time' =>
        test_zci(qr/13:00 \(GMT\) is 8:00 $test_location_tz/,
        html => '-ANY-'
    ),
    '11:22am cest in my timezone' =>
        test_zci(qr/11:22 AM \(CEST, UTC\+2\) is 4:22 AM $test_location_tz/,
        html => '-ANY-'
    ),
    '11:22am cest in localtime' =>
        test_zci(qr/11:22 AM \(CEST, UTC\+2\) is 4:22 AM $test_location_tz/,
        html => '-ANY-'
    ),
    '11:22am cest in my local timezone' =>
        test_zci(qr/11:22 AM \(CEST, UTC\+2\) is 4:22 AM $test_location_tz/,
        html => '-ANY-'
    ),
    '12pm my time in CEST' =>
        test_zci(qr/Noon $test_location_tz is 7:00 PM \(CEST, UTC\+2\)./,
        html => '-ANY-'
    ),
    '12pm local timezone in CEST' =>
        test_zci(qr/Noon $test_location_tz is 7:00 PM \(CEST, UTC\+2\)./,
        html => '-ANY-'
    ),
    '12am my timezone in UTC' =>
        test_zci(qr/Midnight $test_location_tz is 5:00 AM \(UTC\)./,
        html => '-ANY-'
    ),
    '12am local time in UTC' =>
        test_zci(qr/Midnight $test_location_tz is 5:00 AM \(UTC\)./,
        html => '-ANY-'
    ),
);

restore_time();
done_testing;
