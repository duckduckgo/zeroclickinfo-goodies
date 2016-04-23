#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use DDG::Test::Language;

zci answer_type => 'calendar_conversion';
zci is_cached   => 0;

sub build_structured_answer {
    my ($input_date, $converted_date) = @_;
    return "$input_date is $converted_date",
        structured_answer => {
            data => {
                title    => $converted_date,
                subtitle => "Calendar conversion: $input_date"
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

sub language_test {
    my ($language_code, $query, @res_params) = @_;
    my $language = test_language($language_code);
    return DDG::Request->new(
        query_raw => $query,
        language => $language
    ) => test_zci(@res_params);
}

ddg_goodie_test(
    [qw(DDG::Goodie::CalendarConversion)],
    # 'to' forms
    '2003-08-22 to hijri'              => @g22h,
    '2003-08-22 to the hijri calendar' => @g22h,
    '2003-08-22 in the hijri calendar' => @g22h,
    '2003-08-22 in hijri years'        => @g22h,
    # Specifying both calendars
    '1424-06-23 in hijri to gregorian years' => @h23g,
    '1424-06-23 hijri to gregorian'          => @h23g,
    '2003-08-22 to jalali'                   => @g22j,
    '1382-05-31 jalali to gregorian'         => build_test('31 Mordad 1382 (Jalali)', '22 August 2003 (Gregorian)'),
    '1382-05-31 jalali to hijri'             => build_test('31 Mordad 1382 (Jalali)', '23 Jumaada Thani 1424 (Hijri)'),
    '1424-06-23 in hijri to jalali date'     => build_test('23 Jumaada Thani 1424 (Hijri)', '31 Mordad 1382 (Jalali)'),
    # Can use capitals for names
    '2003-08-22 to Hijri' => @g22h,
    # Role contract
    'August 22 2003 in jalali date' => @g22j,
    # To = default
    '2003-08-22 in gregorian time' => undef,
);

done_testing;
