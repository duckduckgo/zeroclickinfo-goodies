#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'calendar_conversion';
zci is_cached   => 0;

my @g22h = (
    '22 August 2003 (Gregorian) is 23 Jumaada Thani 1424 (Hijri)',
    html =>
      "<div class='zci--calendarconversion text--primary'>22 August 2003 (Gregorian) <span class='text--secondary'>is</span> 23 Jumaada Thani 1424 (Hijri)</div>"
);
my @h23g = (
    '23 Jumaada Thani 1424 (Hijri) is 22 August 2003 (Gregorian)',
    html =>
      "<div class='zci--calendarconversion text--primary'>23 Jumaada Thani 1424 (Hijri) <span class='text--secondary'>is</span> 22 August 2003 (Gregorian)</div>"
);
my @g22j = (
    '22 August 2003 (Gregorian) is 31 Mordad 1382 (Jalali)',
    html =>
      "<div class='zci--calendarconversion text--primary'>22 August 2003 (Gregorian) <span class='text--secondary'>is</span> 31 Mordad 1382 (Jalali)</div>"
);

ddg_goodie_test(
    [qw(DDG::Goodie::CalendarConversion)],
    '22/8/2003 to hijri'                    => test_zci(@g22h),
    '22/8/2003 to the hijri calendar'       => test_zci(@g22h),
    '22,8,2003 to hijri'                    => test_zci(@g22h),
    '23/6/1424 in hijri to gregorian years' => test_zci(@h23g),
    '23/6/1424 hijri to gregorian'          => test_zci(@h23g),
    '22/8/2003 to jalali'                   => test_zci(@g22j),
    '31/5/1382 jalali to gregorian'         => test_zci(
        '31 Mordad 1382 (Jalali) is 22 August 2003 (Gregorian)',
        html =>
          "<div class='zci--calendarconversion text--primary'>31 Mordad 1382 (Jalali) <span class='text--secondary'>is</span> 22 August 2003 (Gregorian)</div>",
    ),
    '31/5/1382 jalali to hijri' => test_zci(
        '31 Mordad 1382 (Jalali) is 23 Jumaada Thani 1424 (Hijri)',
        html =>
          "<div class='zci--calendarconversion text--primary'>31 Mordad 1382 (Jalali) <span class='text--secondary'>is</span> 23 Jumaada Thani 1424 (Hijri)</div>"
    ),
    '23/6/1424 in hijri to jalali date' => test_zci(
        '23 Jumaada Thani 1424 (Hijri) is 31 Mordad 1382 (Jalali)',
        html =>
          "<div class='zci--calendarconversion text--primary'>23 Jumaada Thani 1424 (Hijri) <span class='text--secondary'>is</span> 31 Mordad 1382 (Jalali)</div>"
    ),
    'August 22nd, 2003 to jalali'     => test_zci(@g22j),
    '22 Aug 2003 to Hijri'            => test_zci(@g22h),
    '22/8/2003 in the hijri calendar' => test_zci(@g22h),
    '22nd Aug 2003 in jalali'         => test_zci(@g22j),
    '8-22-2003 in hijri years'        => test_zci(@g22h),
    'August 22 2003 in jalali date'   => test_zci(@g22j),
    '22nd Aug 2003 in gregorian time' => undef,
);

done_testing;
