#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'calendar_conversion';
zci is_cached => 0;

ddg_goodie_test(
    [qw(DDG::Goodie::CalendarConversion)],
    '22/8/2003 to hijri' => test_zci(
	'22/8/2003 on the Gregorian calendar is 23/6/1424 on the Hijri calendar.',
	html => '22/8/2003 on the '
	. '<a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> '
	. 'is 23/6/1424 on the '
	. '<a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>.'
    ),
    '22/8/2003 to the hijri calendar' => test_zci(
	'22/8/2003 on the Gregorian calendar is 23/6/1424 on the Hijri calendar.',
	html => '22/8/2003 on the '
	. '<a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> '
	. 'is 23/6/1424 on the '
	. '<a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>.'
    ),
    '22,8,2003 to hijri' => test_zci(
	'22/8/2003 on the Gregorian calendar is 23/6/1424 on the Hijri calendar.',
        html => '22/8/2003 on the '
	. '<a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> '
	. 'is 23/6/1424 on the '
	. '<a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>.'
    ),
    '23/6/1424 in hijri to gregorian years' => test_zci(
	'23/6/1424 on the Hijri calendar is 22/8/2003 on the Gregorian calendar.',
        html => '23/6/1424 on the '
	. '<a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a> '
	. 'is 22/8/2003 on the '
	. '<a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a>.'
    ),
    '23/6/1424 hijri to gregorian' => test_zci(
        '23/6/1424 on the Hijri calendar is 22/8/2003 on the Gregorian calendar.',
        html => '23/6/1424 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a> is 22/8/2003 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a>.'
    ),
    '22/8/2003 to jalali' => test_zci(
	'22/8/2003 on the Gregorian calendar is 31/5/1382 on the Jalali calendar.',
	html => '22/8/2003 on the '
	. '<a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a> '
	. 'is 31/5/1382 on the '
	. '<a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a>.'
    ),
    '31/5/1382 jalali to gregorian' => test_zci(
	'31/5/1382 on the Jalali calendar is 22/8/2003 on the Gregorian calendar.',
	html => '31/5/1382 on the '
	. '<a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a> '
	. 'is 22/8/2003 on the '
	. '<a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a>.'
    ),
    '31/5/1382 jalali to hijri' => test_zci(
	'31/5/1382 on the Jalali calendar is 23/6/1424 on the Hijri calendar.',
	html => '31/5/1382 on the '
	. '<a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a> '
	. 'is 23/6/1424 on the '
	. '<a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>.'
    ),
    '23/6/1424 in hijri to jalali date' => test_zci(
	'23/6/1424 on the Hijri calendar is 31/5/1382 on the Jalali calendar.',
        html => '23/6/1424 on the '
	. '<a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a> '
	. 'is 31/5/1382 on the '
	. '<a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a>.'
    ),
);

done_testing;
