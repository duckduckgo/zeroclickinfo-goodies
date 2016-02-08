#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

my @test_args = (
    '',
    call_type => 'self',
    caller => 'DDG::Spice::Timer'
);

ddg_goodie_test(
    [
        'DDG::Goodie::Timer'
    ],
    'timer' => test_zci(@test_args),
    'timer 15 mins' => test_zci(@test_args),
    'timer 77 mins 13 secs' => test_zci(@test_args),
    'online timer' => test_zci(@test_args),
    'timer online' => test_zci(@test_args),
    'online alarm' => test_zci(@test_args),
    'countdown online' => test_zci(@test_args),
    '1 minute timer' => test_zci(@test_args),
    '2min30sec online timer' => test_zci(@test_args),
    '3 hr 5 min timer' => test_zci(@test_args),
    'timer 30 seconds' => test_zci(@test_args),
    '3.5 minute timer' => test_zci(@test_args),
    'alarm 30 minutes' => test_zci(@test_args),
    'timer for 15 mins' => test_zci(@test_args),
    'timer for 77 mins 13 secs' => test_zci(@test_args),
    'timer 2:30' => test_zci(@test_args),
    'begin timer for 15 mins' => test_zci(@test_args),
    'run timer for 77 mins 13 secs' => test_zci(@test_args),
    'start timer 2:30' => test_zci(@test_args),
    'begin timer with 15 mins' => test_zci(@test_args),
    'run timer at 77 mins 13 secs' => test_zci(@test_args),
    'start timer alarm 2:30' => test_zci(@test_args),
    'begin countdown timer with 15 mins' => test_zci(@test_args),
    'run timer alarm online at 77 mins 13 secs' => test_zci(@test_args),
    'start timer alarm for 2:30 online' => test_zci(@test_args),
    'online start timer alarm for 2:30 online' => test_zci(@test_args),
    'timer 1:20:30' => test_zci(@test_args),
    'countdown for 10 minutes' => test_zci(@test_args),
    'timer online for ' => test_zci(@test_args),
    'Countdown timer' => test_zci(@test_args),
    'Online Countdown timer' => test_zci(@test_args),
    'Countdown timer 15 mins' => test_zci(@test_args),
    'Online Countdown Alarm timer 15 mins' => test_zci(@test_args),
    'online timer' => test_zci(@test_args),
    'online alarm' => test_zci(@test_args),
    'Countdown Alarm timer 15 mins Online' => test_zci(@test_args),
    'online start alarm Timer for 10 minutes online' => test_zci(@test_args),
    'start online CountDown alarm for 10 minutes' => test_zci(@test_args),
    'CountDown Timer with 10 minutes' => test_zci(@test_args),
    'CountDown Timer at 10 minutes' => test_zci(@test_args),
    'countdown online' => test_zci(@test_args),
    '3.5 minute countdown timer' => test_zci(@test_args),
    'begin alarm 30 minutes' => test_zci(@test_args),
    'set alarm 30 minutes' => test_zci(@test_args),
    'begin alarm at 30 minutes' => test_zci(@test_args),
    'set alarm with 30 minutes' => test_zci(@test_args),
    'set alarm with30 minutes' => test_zci(@test_args),
    'countdown timer for 77 mins 13 secs' => test_zci(@test_args),
    'start countdown timer for 77 mins 13 secs' => test_zci(@test_args),
    'start 30 minutes' => undef,
    'start 30 minutes for timer' => undef,
    'run with timer' => undef,
    'begin for 30 seconds' => undef,
    'blahblah timer' => undef,
    'wwdc 2015 countdown' => undef,
    'timer 5 hellos' => undef,
    'time' => undef,
    'Time::Piece' => undef,
    'timer.x' => undef,
    'countdown.x' => undef,
    'alarm.x' => undef,
    'countdown.js 10 minutes' => undef,
    'five-alarm' => undef # issue 1937
);

done_testing;
