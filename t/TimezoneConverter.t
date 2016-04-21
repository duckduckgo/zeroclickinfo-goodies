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
    '3:14 UTC in GMT' =>
        test_zci('3:14 GMT',
        structured_answer => {
            input => ['3:14 UTC to GMT'],
            operation => 'Convert Timezone',
            result => '3:14 GMT',
        },
    ),
    '8:10 AM AZOST into CAT' =>
        test_zci('11:10 AM CAT',
        structured_answer => {
            input => ['8:10 AM AZOST (UTC-1) to CAT (UTC+2)'],
            operation => 'Convert Timezone',
            result => '11:10 AM CAT',
        },
    ),
    '1pm EDT into UTC+2' =>
        test_zci('7:00 PM UTC+2',
        structured_answer => {
            input => ['1:00 PM EDT (UTC-4) to UTC+2'],
            operation => 'Convert Timezone',
            result => '7:00 PM UTC+2',
        },
    ),
    '0pm UTC into GMT' =>
        test_zci('Noon GMT',
        structured_answer => {
            input => ['Noon UTC to GMT'],
            operation => 'Convert Timezone',
            result => 'Noon GMT',
        },
    ),
    '0am UTC into UTC' =>
        test_zci('Midnight UTC',
        structured_answer => {
            input => ['Midnight UTC to UTC'],
            operation => 'Convert Timezone',
            result => 'Midnight UTC',
        },
    ),
    '1 UTC into UTC -2 ' =>
        test_zci('23:00 UTC-2 (1 day prior)',
        structured_answer => {
            input => ['1:00 UTC to UTC-2'],
            operation => 'Convert Timezone',
            result => '23:00 UTC-2 (1 day prior)',
        },
    ),
    ' 1 UTC into UTC-1' =>
        test_zci('0:00 UTC-1',
        structured_answer => {
            input => ['1:00 UTC to UTC-1'],
            operation => 'Convert Timezone',
            result => '0:00 UTC-1',
        },
    ),
    '21 FNT into EET' =>
        test_zci('1:00 EET (1 day after)',
        structured_answer => {
            input => ['21:00 FNT (UTC-2) to EET (UTC+2)'],
            operation => 'Convert Timezone',
            result => '1:00 EET (1 day after)',
        },
    ),
    '23:00:00  UTC InTo  UTC+1' =>
        test_zci('0:00 UTC+1 (1 day after)',
        structured_answer => {
            input => ['23:00 UTC to UTC+1'],
            operation => 'Convert Timezone',
            result => '0:00 UTC+1 (1 day after)',
        },
    ),
    '23:00:01  UTC Into    UTC+1' =>
        test_zci('0:00:01 UTC+1 (1 day after)',
        structured_answer => {
            input => ['23:00:01 UTC to UTC+1'],
            operation => 'Convert Timezone',
            result => '0:00:01 UTC+1 (1 day after)',
        },
    ),
    '13:15:00 UTC-0:30 into UTC+0:30' =>
        test_zci('13:15 UTC+0:30',
        structured_answer => {
            input => ['13:15 UTC-0:30 to UTC+0:30'],
            operation => 'Convert Timezone',
            result => '13:15 UTC+0:30',
        },
    ),
    # ok, this is unlikely to happen without trying to do that
    '19:42:42 BIT into GMT+100' =>
        test_zci('11:42:42 GMT+100 (5 days after)',
        structured_answer => {
            input => ['19:42:42 BIT (UTC-12) to GMT+100'],
            operation => 'Convert Timezone',
            result => '11:42:42 GMT+100 (5 days after)',
        },
    ),
    '19:42:42 CHADT into GMT-100' =>
        test_zci('1:57:42 GMT-100 (4 days prior)',
        structured_answer => {
            input => ['19:42:42 CHADT (UTC+13:45) to GMT-100'],
            operation => 'Convert Timezone',
            result => '1:57:42 GMT-100 (4 days prior)',
        },
    ),
    '10:00AM MST to PST' =>
        test_zci('9:00 AM PST',
        structured_answer => {
            input => ['10:00 AM MST (UTC-7) to PST (UTC-8)'],
            operation => 'Convert Timezone',
            result => '9:00 AM PST',
        },
    ),
    '19:00 UTC to EST' =>
        test_zci('14:00 EST',
        structured_answer => {
            input => ['19:00 UTC to EST (UTC-5)'],
            operation => 'Convert Timezone',
            result => '14:00 EST',
        },
    ),
    '1am UTC to PST' =>
        test_zci('5:00 PM PST (1 day prior)',
        structured_answer => {
            input => ['1:00 AM UTC to PST (UTC-8)'],
            operation => 'Convert Timezone',
            result => '5:00 PM PST (1 day prior)',
        },
    ),
    '12:40pm PST into JST' =>
        test_zci('5:40 AM JST (1 day after)',
        structured_answer => {
            input => ['12:40 PM PST (UTC-8) to JST (UTC+9)'],
            operation => 'Convert Timezone',
            result => '5:40 AM JST (1 day after)',
        },
    ),
    '12:40 pm from PST to JST' =>
        test_zci('5:40 AM JST (1 day after)',
        structured_answer => {
            input => ['12:40 PM PST (UTC-8) to JST (UTC+9)'],
            operation => 'Convert Timezone',
            result => '5:40 AM JST (1 day after)',
        },
    ),
    '11:22am est in utc' =>
        test_zci('4:22 PM UTC',
        structured_answer => {
            input => ['11:22 AM EST (UTC-5) to UTC'],
            operation => 'Convert Timezone',
            result => '4:22 PM UTC',
        },
    ),
      '1600 UTC in BST' =>
        test_zci('17:00 BST',
        structured_answer => {
            input => ['16:00 UTC to BST (UTC+1)'],
            operation => 'Convert Timezone',
            result => '17:00 BST',
        },
    ),  
    '12:00 GMT in PST' =>
        test_zci('4:00 PST',
        structured_answer => {
            input => ['12:00 GMT to PST (UTC-8)'],
            operation => 'Convert Timezone',
            result => '4:00 PST',
        },
    ),
    
    # Intentional non-answers
    '12 in binary' => undef,
);


# Summertime
my $test_location_tz = q/EDT (UTC-4)/;
set_fixed_time("2014-10-14T00:00:00");
ddg_goodie_test(
    ['DDG::Goodie::TimezoneConverter'],
    # Location-specific tests (variable with DST)
    '13:00 GMT in my time' =>
        test_zci(q/9:00 EDT/,
        structured_answer => {
            input => [qq/13:00 GMT to $test_location_tz/],
            operation => 'Convert Timezone',
            result => q/9:00 EDT/,
        },
    ),
    '13:00 GMT' =>
        test_zci(q/9:00 EDT/,
        structured_answer => {
            input => [qq/13:00 GMT to $test_location_tz/],
            operation => 'Convert Timezone',
            result => q/9:00 EDT/,
        },
    ),
    '11:22am cest in my timezone' =>
        test_zci(qr/5:22 AM EDT/,
        structured_answer => {
            input => [qq/11:22 AM CEST (UTC+2) to $test_location_tz/],
            operation => 'Convert Timezone',
            result => qr/5:22 AM EDT/,
        },
    ),
    '11:22am cest in localtime' =>
        test_zci(qr/5:22 AM EDT/,
        structured_answer => {
            input => [qq/11:22 AM CEST (UTC+2) to $test_location_tz/],
            operation => 'Convert Timezone',
            result => qr/5:22 AM EDT/,
        },
    ),
    '11:22am cest in my local timezone' =>
        test_zci(qr/5:22 AM EDT/,
        structured_answer => {
            input => [qq/11:22 AM CEST (UTC+2) to $test_location_tz/],
            operation => 'Convert Timezone',
            result => qr/5:22 AM EDT/,
        },
    ),
    '11:22am cest' =>
        test_zci(qr/5:22 AM EDT/,
        structured_answer => {
            input => [qq/11:22 AM CEST (UTC+2) to $test_location_tz/],
            operation => 'Convert Timezone',
            result => qr/5:22 AM EDT/,
        },
    ),
    '12pm my time in CEST' =>
        test_zci(q/6:00 PM CEST/,
        structured_answer => {
            input => [qq/Noon $test_location_tz to CEST (UTC+2)/],
            operation => 'Convert Timezone',
            result => q/6:00 PM CEST/,
        },
    ),
    '12pm local timezone in CEST' =>
        test_zci(q/6:00 PM CEST/,
        structured_answer => {
            input => [qq/Noon $test_location_tz to CEST (UTC+2)/],
            operation => 'Convert Timezone',
            result => q/6:00 PM CEST/,
        },
    ),
    '12pm in CEST' =>
        test_zci(q/6:00 PM CEST/,
        structured_answer => {
            input => [qq/Noon $test_location_tz to CEST (UTC+2)/],
            operation => 'Convert Timezone',
            result => q/6:00 PM CEST/,
        },
    ),
    '12am my timezone in UTC' =>
        test_zci(q/4:00 AM UTC/,
        structured_answer => {
            input => [qq/Midnight $test_location_tz to UTC/],
            operation => 'Convert Timezone',
            result => q/4:00 AM UTC/,
        },
    ),
    '12am local time in UTC' =>
        test_zci(q/4:00 AM UTC/,
        structured_answer => {
            input => [qq/Midnight $test_location_tz to UTC/],
            operation => 'Convert Timezone',
            result => q/4:00 AM UTC/,
        },
    ),
    '12am in UTC' =>
        test_zci(q/4:00 AM UTC/,
        structured_answer => {
            input => [qq/Midnight $test_location_tz to UTC/],
            operation => 'Convert Timezone',
            result => q/4:00 AM UTC/,
        },
    )
);
restore_time();

set_fixed_time("2014-11-02T11:00:00");
$test_location_tz = 'EST (UTC-5)';
ddg_goodie_test(
    ['DDG::Goodie::TimezoneConverter'],
    # Location-specific tests (variable with DST)
    '13:00 GMT in my time' =>
        test_zci(qq/8:00 EST/,
        structured_answer => {
            input => [qq/13:00 GMT to $test_location_tz/],
            operation => 'Convert Timezone',
            result => q/8:00 EST/,
        },
    ),
    '13:00 GMT' =>
        test_zci(qq/8:00 EST/,
        structured_answer => {
            input => [qq/13:00 GMT to $test_location_tz/],
            operation => 'Convert Timezone',
            result => q/8:00 EST/,
        },
    ),
    '11:22am cest in my timezone' =>
        test_zci(qr/4:22 AM EST/,
        structured_answer => {
            input => [qq/11:22 AM CEST (UTC+2) to $test_location_tz/],
            operation => 'Convert Timezone',
            result => qr/4:22 AM EST/,
        },
    ),
    '11:22am cest in localtime' =>
        test_zci(qr/4:22 AM EST/,
        structured_answer => {
            input => [qq/11:22 AM CEST (UTC+2) to $test_location_tz/],
            operation => 'Convert Timezone',
            result => qr/4:22 AM EST/,
        },
    ),
    '11:22am cest in my local timezone' =>
        test_zci(q/4:22 AM EST/,
        structured_answer => {
            input => [qq/11:22 AM CEST (UTC+2) to $test_location_tz/],
            operation => 'Convert Timezone',
            result => q/4:22 AM EST/,
        },
    ),
    '11:22am cest' =>
        test_zci(q/4:22 AM EST/,
        structured_answer => {
            input => [qq/11:22 AM CEST (UTC+2) to $test_location_tz/],
            operation => 'Convert Timezone',
            result => q/4:22 AM EST/,
        },
    ),
    '12pm my time in CEST' =>
        test_zci(q/7:00 PM CEST/,
        structured_answer => {
            input => [qq/Noon $test_location_tz to CEST (UTC+2)/],
            operation => 'Convert Timezone',
            result => q/7:00 PM CEST/,
        },
    ),
    '12pm local timezone in CEST' =>
        test_zci(q/7:00 PM CEST/,
        structured_answer => {
            input => [qq/Noon $test_location_tz to CEST (UTC+2)/],
            operation => 'Convert Timezone',
            result => q/7:00 PM CEST/,
        },
    ),
    '12pm in CEST' =>
        test_zci(q/7:00 PM CEST/,
        structured_answer => {
            input => [qq/Noon $test_location_tz to CEST (UTC+2)/],
            operation => 'Convert Timezone',
            result => q/7:00 PM CEST/,
        },
    ),
    '12am my timezone in UTC' =>
        test_zci(qr/5:00 AM UTC/,
        structured_answer => {
            input => [qq/Midnight $test_location_tz to UTC/],
            operation => 'Convert Timezone',
            result => q/5:00 AM UTC/,
        },
    ),
    '12am local time in UTC' =>
        test_zci(qr/5:00 AM UTC/,
        structured_answer => {
            input => [qq/Midnight $test_location_tz to UTC/],
            operation => 'Convert Timezone',
            result => q/5:00 AM UTC/,
        },
    ),
    '12am in UTC' =>
        test_zci(qr/5:00 AM UTC/,
        structured_answer => {
            input => [qq/Midnight $test_location_tz to UTC/],
            operation => 'Convert Timezone',
            result => q/5:00 AM UTC/,
        },
    ),
);

restore_time();
done_testing;
