#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'timer';
zci is_cached   => 1;

sub build_structured_answer {
    return '',
        structured_answer => {
            id     =>  'timer',
            name   => 'Timer',
            signal => 'high',
            meta => {
                sourceName => 'Timer',
                itemType   => 'timer',
            },
            templates => {
                detail      => 'DDH.timer.timer_wrapper',
                wrap_detail => 'base_detail',
            },
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [
        'DDG::Goodie::Timer'
    ],
    # With no initial time
    'timer'                  => build_test(),
    'online timer'           => build_test(),
    'timer online'           => build_test(),
    'online alarm'           => build_test(),
    'countdown online'       => build_test(),
    'online timer'           => build_test(),
    'online alarm'           => build_test(),
    'countdown online'       => build_test(),
    'timer online for '      => build_test(),
    'Countdown timer'        => build_test(),
    'Online Countdown timer' => build_test(),

    # With initial time
    'timer 15 mins'                                  => build_test(),
    'timer 77 mins 13 secs'                          => build_test(),
    '1 minute timer'                                 => build_test(),
    '2min30sec online timer'                         => build_test(),
    '3 hr 5 min timer'                               => build_test(),
    'timer 30 seconds'                               => build_test(),
    '3.5 minute timer'                               => build_test(),
    'alarm 30 minutes'                               => build_test(),
    'timer for 15 mins'                              => build_test(),
    'timer for 77 mins 13 secs'                      => build_test(),
    'timer 2:30'                                     => build_test(),
    'begin timer for 15 mins'                        => build_test(),
    'run timer for 77 mins 13 secs'                  => build_test(),
    'start timer 2:30'                               => build_test(),
    'begin timer with 15 mins'                       => build_test(),
    'run timer at 77 mins 13 secs'                   => build_test(),
    'start timer alarm 2:30'                         => build_test(),
    'begin countdown timer with 15 mins'             => build_test(),
    'run timer alarm online at 77 mins 13 secs'      => build_test(),
    'start timer alarm for 2:30 online'              => build_test(),
    'online start timer alarm for 2:30 online'       => build_test(),
    'timer 1:20:30'                                  => build_test(),
    'countdown for 10 minutes'                       => build_test(),
    'Countdown timer 15 mins'                        => build_test(),
    'Online Countdown Alarm timer 15 mins'           => build_test(),
    'Countdown Alarm timer 15 mins Online'           => build_test(),
    'online start alarm Timer for 10 minutes online' => build_test(),
    'start online CountDown alarm for 10 minutes'    => build_test(),
    'CountDown Timer with 10 minutes'                => build_test(),
    'CountDown Timer at 10 minutes'                  => build_test(),
    '3.5 minute countdown timer'                     => build_test(),
    'begin alarm 30 minutes'                         => build_test(),
    'set alarm 30 minutes'                           => build_test(),
    'begin alarm at 30 minutes'                      => build_test(),
    'set alarm with 30 minutes'                      => build_test(),
    'set alarm with30 minutes'                       => build_test(),
    'countdown timer for 77 mins 13 secs'            => build_test(),
    'start countdown timer for 77 mins 13 secs'      => build_test(),
    # Should not trigger
    'start 30 minutes'           => undef,
    'start 30 minutes for timer' => undef,
    'run with timer'             => undef,
    'begin for 30 seconds'       => undef,
    'blahblah timer'             => undef,
    'wwdc 2015 countdown'        => undef,
    'timer 5 hellos'             => undef,
    'time'                       => undef,
    'Time::Piece'                => undef,
    'timer.x'                    => undef,
    'countdown.x'                => undef,
    'alarm.x'                    => undef,
    'countdown.js 10 minutes'    => undef,
    'five-alarm'                 => undef # issue 1937
);

done_testing;
