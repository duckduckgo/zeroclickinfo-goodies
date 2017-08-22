#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'timer';
zci is_cached   => 1;

# Get Goodie version for use with image paths
my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

sub build_structured_answer {
    my $time = shift;
    $time = $time || 0;
    return "$time",
        structured_answer => {
            id     =>  'timer',
            name   => 'Timer',
            signal => 'high',
            meta => {
                sourceName => 'Timer',
                itemType   => 'timer',
            },
            data => {
                time => "$time",
                goodie_version => $goodieVersion
            },
            templates => {
                group       => 'base',
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
    'count down timer'       => build_test(),

    # With initial time
    'timer 15 mins'                                  => build_test('900'),
    'timer 77 mins 13 secs'                          => build_test('4633'),
    '1 minute timer'                                 => build_test('60'),
    '2min30sec online timer'                         => build_test('150'),
    '3 hr 5 min timer'                               => build_test('11100'),
    'timer 30 seconds'                               => build_test('30'),
    '3.5 minute timer'                               => build_test('210'),
    'alarm 30 minutes'                               => build_test('1800'),
    'timer for 15 mins'                              => build_test('900'),
    'timer for 77 mins 13 secs'                      => build_test('4633'),
    'timer 2:30'                                     => build_test('150'),
    'begin timer for 15 mins'                        => build_test('900'),
    'run timer for 77 mins 13 secs'                  => build_test('4633'),
    'start timer 2:30'                               => build_test('150'),
    'begin timer with 15 mins'                       => build_test('900'),
    'run timer at 77 mins 13 secs'                   => build_test('4633'),
    'start timer alarm 2:30'                         => build_test('150'),
    'begin countdown timer with 15 mins'             => build_test('900'),
    'run timer alarm online at 77 mins 13 secs'      => build_test('4633'),
    'start timer alarm for 2:30 online'              => build_test('150'),
    'online start timer alarm for 2:30 online'       => build_test('150'),
    'timer 1:20:30'                                  => build_test('4830'),
    'timer 5s'                                       => build_test('5'),
    'timer 5m'                                       => build_test('300'),
    'timer 5h'                                       => build_test('18000'),
    'countdown for 10 minutes'                       => build_test('600'),
    'Countdown timer 15 mins'                        => build_test('900'),
    'Online Countdown Alarm timer 15 mins'           => build_test('900'),
    'Countdown Alarm timer 15 mins Online'           => build_test('900'),
    'online start alarm Timer for 10 minutes online' => build_test('600'),
    'start online CountDown alarm for 10 minutes'    => build_test('600'),
    'CountDown Timer with 10 minutes'                => build_test('600'),
    'CountDown Timer at 10 minutes'                  => build_test('600'),
    '3.5 minute countdown timer'                     => build_test('210'),
    'begin alarm 30 minutes'                         => build_test('1800'),
    'set alarm 30 minutes'                           => build_test('1800'),
    'begin alarm at 30 minutes'                      => build_test('1800'),
    'set alarm with 30 minutes'                      => build_test('1800'),
    'set alarm with30 minutes'                       => build_test('1800'),
    'countdown timer for 77 mins 13 secs'            => build_test('4633'),
    'start countdown timer for 77 mins 13 secs'      => build_test('4633'),
    '10 minutes'                                     => build_test('600'),
    '20 mins'                                        => build_test('1200'),
    'timer 20 minutes'                               => build_test('1200'),
    'timer 60 minutes'                               => build_test('3600'),
    'start a timer for 20 minutes'                   => build_test('1200'),
    'set a timer to 60 minutes'                      => build_test('3600'),
    'set a timer of 60 minutes'                      => build_test('3600'),
    'timer of 5:15 mins'                             => build_test('315'),          
    # Should not trigger
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
    'five-alarm'                 => undef, # issue 1937
    '20 minutes'                 => undef,
    ' 22 minutes'                 => undef,
    '60 minutes'                 => undef,
    '48 hours  '                   => undef,
    '5:15 + 32 minutes'          => undef,
    '3:32 - 8 mins'              => undef
);

done_testing;
