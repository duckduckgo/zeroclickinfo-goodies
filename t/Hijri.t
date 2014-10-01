#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Date::Hijri;

zci answer_type => 'conversion';
zci is_cached   => 1;

ddg_goodie_test(
    [qw(DDG::Goodie::Hijri)],
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
    '23/6/1424 to gregorian years' => test_zci(
	'23/6/1424 on the Hijri calendar is 22/8/2003 on the Gregorian calendar.',
        html => '23/6/1424 on the '
	. '<a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a> '
	. 'is 22/8/2003 on the '
	. '<a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a>.'
    ),
    '23/6/1424 to gregorian' => test_zci(
        '23/6/1424 on the Hijri calendar is 22/8/2003 on the Gregorian calendar.',
        html => '23/6/1424 on the <a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a> is 22/8/2003 on the <a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a>.'
    ),
);

done_testing;
