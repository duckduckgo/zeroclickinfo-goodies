#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

zci answer_type => 'timezone_converter';
zci is_cached   => 1;

sub build_test {
    my ($text, $input) = @_;
    return test_zci($text, structured_answer => {
       data => {
           title => $text,
           subtitle => "Convert Timezone: $input"
       },
       templates => {
           group => 'text',
           options => {
               moreAt => 0,
           }
       }
    });
}

ddg_goodie_test(
    ['DDG::Goodie::TimezoneConverter'],
    '3:14 UTC in GMT' => build_test('3:14 GMT', '3:14 UTC to GMT'),
    '8:10 AM AZOST into CAT' => build_test('11:10 AM CAT', '8:10 AM AZOST (UTC-1) to CAT (UTC+2)'),
    '1pm EDT into UTC+2' => build_test('7:00 PM UTC+2', '1:00 PM EDT (UTC-4) to UTC+2'),
    '0pm UTC into GMT' => build_test('Noon - 12:00 PM GMT', 'Noon - 12:00 PM UTC to GMT'),
    '0am UTC into UTC' => build_test('Midnight - 12:00 AM UTC', 'Midnight - 12:00 AM UTC to UTC'),
    '1 UTC into UTC -2 ' => build_test('23:00 UTC-2 (1 day prior)', '1:00 UTC to UTC-2'),
    ' 1 UTC into UTC-1' => build_test('0:00 UTC-1', '1:00 UTC to UTC-1'),
    '21 FNT into EET' => build_test('1:00 EET (1 day after)', '21:00 FNT (UTC-2) to EET (UTC+2)'),
    '23:00:00  UTC InTo  UTC+1' => build_test('0:00 UTC+1 (1 day after)', '23:00 UTC to UTC+1'),
    '23:00:01  UTC Into    UTC+1' => build_test('0:00:01 UTC+1 (1 day after)', '23:00:01 UTC to UTC+1'),
    '13:15:00 UTC-0:30 into UTC+0:30' => build_test('13:15 UTC+0:30', '13:15 UTC-0:30 to UTC+0:30'),
    # ok, this is unlikely to happen without trying to do that
    '19:42:42 BIT into GMT+100' => build_test('11:42:42 GMT+100 (5 days after)', '19:42:42 BIT (UTC-12) to GMT+100'),
    '19:42:42 CHADT into GMT-100' => build_test('1:57:42 GMT-100 (4 days prior)', '19:42:42 CHADT (UTC+13:45) to GMT-100'),
    '10:00AM MST to PST' => build_test('9:00 AM PST', '10:00 AM MST (UTC-7) to PST (UTC-8)'),
    '19:00 UTC to EST' => build_test('14:00 EST', '19:00 UTC to EST (UTC-5)'),
    '1am UTC to PST' => build_test('5:00 PM PST (1 day prior)', '1:00 AM UTC to PST (UTC-8)'),
    '12:40pm PST into JST' => build_test('5:40 AM JST (1 day after)', '12:40 PM PST (UTC-8) to JST (UTC+9)'),
    '12:40 pm from PST to JST' => build_test('5:40 AM JST (1 day after)', '12:40 PM PST (UTC-8) to JST (UTC+9)'),
    '11:22am est in utc' => build_test('4:22 PM UTC', '11:22 AM EST (UTC-5) to UTC'),
    '1600 UTC in BST' => build_test('17:00 BST', '16:00 UTC to BST (UTC+1)'),  
    '12:00 GMT in PST' => build_test('4:00 PST', '12:00 GMT to PST (UTC-8)'),
    '10:00PM EDT to NDT' => build_test('11:30 PM NDT', '10:00 PM EDT (UTC-4) to NDT (UTC-2:30)'),
    '10:00AM MST to NST' => build_test('1:30 PM NST', '10:00 AM MST (UTC-7) to NST (UTC-3:30)'),
    '1:40AM PDT to MIT' => build_test('11:10 PM MIT (1 day prior)', '1:40 AM PDT (UTC-7) to MIT (UTC-9:30)'),
    
    # Intentional non-answers
    '12 in binary' => undef,
);


# Summertime
my $test_location_tz = q/EDT (UTC-4)/;
set_fixed_time("2014-10-14T00:00:00");
ddg_goodie_test(
    ['DDG::Goodie::TimezoneConverter'],
    # Location-specific tests (variable with DST)
    '13:00 GMT in my time' => build_test(q/9:00 EDT/, qq/13:00 GMT to $test_location_tz/),
    '13:00 GMT' => build_test(q/9:00 EDT/, qq/13:00 GMT to $test_location_tz/),
    '11:22am cest in my timezone' => build_test(re(qr/5:22 AM EDT/), qq/11:22 AM CEST (UTC+2) to $test_location_tz/),
    '11:22am cest in localtime' => build_test(re(qr/5:22 AM EDT/), qq/11:22 AM CEST (UTC+2) to $test_location_tz/),
    '11:22am cest in my local timezone' => build_test(re(qr/5:22 AM EDT/), qq/11:22 AM CEST (UTC+2) to $test_location_tz/),
    '11:22am cest' =>  build_test(re(qr/5:22 AM EDT/), qq/11:22 AM CEST (UTC+2) to $test_location_tz/),
    '12pm my time in CEST' => build_test(q/6:00 PM CEST/, qq/Noon - 12:00 PM $test_location_tz to CEST (UTC+2)/),
    '12pm local timezone in CEST' =>  build_test(q/6:00 PM CEST/, qq/Noon - 12:00 PM $test_location_tz to CEST (UTC+2)/),
    '12pm in CEST' => build_test(q/6:00 PM CEST/, qq/Noon - 12:00 PM $test_location_tz to CEST (UTC+2)/),
    '12am my timezone in UTC' => build_test(q/4:00 AM UTC/, qq/Midnight - 12:00 AM $test_location_tz to UTC/),
    '12am local time in UTC' => build_test(q/4:00 AM UTC/, qq/Midnight - 12:00 AM $test_location_tz to UTC/),
    '12am in UTC' => build_test(q/4:00 AM UTC/, qq/Midnight - 12:00 AM $test_location_tz to UTC/)
);
restore_time();

set_fixed_time("2014-11-02T11:00:00");
$test_location_tz = 'EST (UTC-5)';
ddg_goodie_test(
    ['DDG::Goodie::TimezoneConverter'],
    # Location-specific tests (variable with DST)
    '13:00 GMT in my time' => build_test(qq/8:00 EST/, qq/13:00 GMT to $test_location_tz/),
    '13:00 GMT' => build_test(qq/8:00 EST/, qq/13:00 GMT to $test_location_tz/),
    '11:22am cest in my timezone' => build_test(re(qr/4:22 AM EST/), qq/11:22 AM CEST (UTC+2) to $test_location_tz/),
    '11:22am cest in localtime' => build_test(re(qr/4:22 AM EST/), qq/11:22 AM CEST (UTC+2) to $test_location_tz/),
    '11:22am cest in my local timezone' => build_test(q/4:22 AM EST/, qq/11:22 AM CEST (UTC+2) to $test_location_tz/),
    '11:22am cest' => build_test(q/4:22 AM EST/, qq/11:22 AM CEST (UTC+2) to $test_location_tz/),
    '12pm my time in CEST' => build_test(q/7:00 PM CEST/, qq/Noon - 12:00 PM $test_location_tz to CEST (UTC+2)/),
    '12pm local timezone in CEST' => build_test(q/7:00 PM CEST/, qq/Noon - 12:00 PM $test_location_tz to CEST (UTC+2)/),
    '12pm in CEST' => build_test(q/7:00 PM CEST/, qq/Noon - 12:00 PM $test_location_tz to CEST (UTC+2)/),
    '12am my timezone in UTC' => build_test(re(qr/5:00 AM UTC/), qq/Midnight - 12:00 AM $test_location_tz to UTC/),
    '12am local time in UTC' => build_test(re(qr/5:00 AM UTC/), qq/Midnight - 12:00 AM $test_location_tz to UTC/),
    '12am in UTC' => build_test(re(qr/5:00 AM UTC/), qq/Midnight - 12:00 AM $test_location_tz to UTC/),
);

restore_time();
done_testing;
