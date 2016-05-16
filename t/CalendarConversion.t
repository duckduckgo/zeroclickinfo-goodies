#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'calendar_conversion';
zci is_cached   => 0;

sub build_structured_answer {
    my ($input_date, $converted_date) = @_;
    return $input_date . ' is ' . $converted_date,
        structured_answer => {
            data => {
                title => $converted_date,
                subtitle => 'Calendar conversion: ' . $input_date
            },
            templates => {
                group => 'text'
            }
    };
}

sub build_test { test_zci(build_structured_answer(@_)) }

my @g22h = (build_test('22 August 2003 (Gregorian)', '23 Jumaada Thani 1424 (Hijri)'));
my @h23g = (build_test('23 Jumaada Thani 1424 (Hijri)', '22 August 2003 (Gregorian)'));
my @g22j = (build_test('22 August 2003 (Gregorian)', '31 Mordad 1382 (Jalali)'));

ddg_goodie_test(
    [qw(DDG::Goodie::CalendarConversion)],
    '22/8/2003 to hijri'                    => @g22h,
    '22/8/2003 to the hijri calendar'       => @g22h,
    '22,8,2003 to hijri'                    => @g22h,
    '23/6/1424 in hijri to gregorian years' => @h23g,
    '23/6/1424 hijri to gregorian'          => @h23g,
    '22/8/2003 to jalali'                   => @g22j,
    '31/5/1382 jalali to gregorian'         => build_test('31 Mordad 1382 (Jalali)', '22 August 2003 (Gregorian)'),
    '31/5/1382 jalali to hijri'             => build_test('31 Mordad 1382 (Jalali)', '23 Jumaada Thani 1424 (Hijri)'),
    '23/6/1424 in hijri to jalali date'     => build_test('23 Jumaada Thani 1424 (Hijri)', '31 Mordad 1382 (Jalali)'),
    'August 22nd, 2003 to jalali'           => @g22j,
    '22 Aug 2003 to Hijri'                  => @g22h,
    '22/8/2003 in the hijri calendar'       => @g22h,
    '22nd Aug 2003 in jalali'               => @g22j,
    '8-22-2003 in hijri years'              => @g22h,
    'August 22 2003 in jalali date'         => @g22j,
    '22nd Aug 2003 in gregorian time'       => undef,
);

done_testing;
