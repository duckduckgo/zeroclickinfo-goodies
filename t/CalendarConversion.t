#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'calendar_conversion';
zci is_cached   => 0;

ddg_goodie_test(
    [qw(DDG::Goodie::CalendarConversion)],
    '22/8/2003 to hijri' => test_zci(
        '2003-08-22 on the Gregorian calendar is 1424-06-23 on the Hijri calendar.',
        html =>
          '2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> is 1424-06-23 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>.'
    ),
    '22/8/2003 to the hijri calendar' => test_zci(
        '2003-08-22 on the Gregorian calendar is 1424-06-23 on the Hijri calendar.',
        html =>
          '2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> is 1424-06-23 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>.'
    ),
    '22,8,2003 to hijri' => test_zci(
        '2003-08-22 on the Gregorian calendar is 1424-06-23 on the Hijri calendar.',
        html =>
          '2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> is 1424-06-23 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>.'
    ),
    '23/6/1424 in hijri to gregorian years' => test_zci(
        '1424-06-23 on the Hijri calendar is 2003-08-22 on the Gregorian calendar.',
        html =>
          '1424-06-23 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a> is 2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a>.'
    ),
    '23/6/1424 hijri to gregorian' => test_zci(
        '1424-06-23 on the Hijri calendar is 2003-08-22 on the Gregorian calendar.',
        html =>
          '1424-06-23 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a> is 2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a>.'
    ),
    '22/8/2003 to jalali' => test_zci(
        '2003-08-22 on the Gregorian calendar is 1382-05-31 on the Jalali calendar.',
        html =>
          '2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> is 1382-05-31 on the <a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a>.'
    ),
    '31/5/1382 jalali to gregorian' => test_zci(
        '1382-05-31 on the Jalali calendar is 2003-08-22 on the Gregorian calendar.',
        html =>
          '1382-05-31 on the <a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a> is 2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a>.'
    ),
    '31/5/1382 jalali to hijri' => test_zci(
        '1382-05-31 on the Jalali calendar is 1424-06-23 on the Hijri calendar.',
        html =>
          '1382-05-31 on the <a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a> is 1424-06-23 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>.'
    ),
    '23/6/1424 in hijri to jalali date' => test_zci(
        '1424-06-23 on the Hijri calendar is 1382-05-31 on the Jalali calendar.',
        html =>
          '1424-06-23 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a> is 1382-05-31 on the <a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a>.'
    ),
    'August 22nd, 2003 to jalali' => test_zci(
        '2003-08-22 on the Gregorian calendar is 1382-05-31 on the Jalali calendar.',
        html =>
          '2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> is 1382-05-31 on the <a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a>.'
    ),
    '22 Aug 2003 to Hijri' => test_zci(
        '2003-08-22 on the Gregorian calendar is 1424-06-23 on the Hijri calendar.',
        html =>
          '2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> is 1424-06-23 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>.'
    ),
    '22/8/2003 in the hijri calendar' => test_zci(
        '2003-08-22 on the Gregorian calendar is 1424-06-23 on the Hijri calendar.',
        html =>
          '2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> is 1424-06-23 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>.'
    ),
    '22nd Aug 2003 in jalali' => test_zci(
        '2003-08-22 on the Gregorian calendar is 1382-05-31 on the Jalali calendar.',
        html =>
          '2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> is 1382-05-31 on the <a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a>.'
    ),
    '8-22-2003 in hijri years' => test_zci(
        '2003-08-22 on the Gregorian calendar is 1424-06-23 on the Hijri calendar.',
        html =>
          '2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> is 1424-06-23 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>.'
    ),
    'August 22 2003 in jalali date' => test_zci(
        '2003-08-22 on the Gregorian calendar is 1382-05-31 on the Jalali calendar.',
        html =>
          '2003-08-22 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> is 1382-05-31 on the <a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a>.'
    ),
    '22nd Aug 2003 in gregorian time' => undef,
);

done_testing;
