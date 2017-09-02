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
    my $autoPlay = shift;
    $autoPlay = $autoPlay || 0;
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
                should_autostart => $autoPlay,
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
    'pomodoro timer'         => build_test('1500',0),
    'pomodoro countdown'     => build_test('1500',0),
    'online pomodoro timer'  => build_test('1500',0),			
				
    # With initial time
    'timer 15 mins'                                  => build_test('900',1),
    'timer 77 mins 13 secs'                          => build_test('4633',1),
    '1 minute timer'                                 => build_test('60',1),
    '2min30sec online timer'                         => build_test('150',1),
    '3 hr 5 min timer'                               => build_test('11100',1),
    'timer 30 seconds'                               => build_test('30',1),
    '3.5 minute timer'                               => build_test('210',1),
    'alarm 30 minutes'                               => build_test('1800',1),
    'timer for 15 mins'                              => build_test('900',1),
    'timer for 77 mins 13 secs'                      => build_test('4633',1),
    'timer 2:30'                                     => build_test('150',1),
    'begin timer for 15 mins'                        => build_test('900',1),
    'run timer for 77 mins 13 secs'                  => build_test('4633',1),
    'start timer 2:30'                               => build_test('150',1),
    'begin timer with 15 mins'                       => build_test('900',1),
    'run timer at 77 mins 13 secs'                   => build_test('4633',1),
    'start timer alarm 2:30'                         => build_test('150',1),
    'begin countdown timer with 15 mins'             => build_test('900',1),
    'run timer alarm online at 77 mins 13 secs'      => build_test('4633',1),
    'start timer alarm for 2:30 online'              => build_test('150',1),
    'online start timer alarm for 2:30 online'       => build_test('150',1),
    'timer 1:20:30'                                  => build_test('4830',1),
    'timer 5s'                                       => build_test('5',1),
    'timer 5m'                                       => build_test('300',1),
    'timer 5h'                                       => build_test('18000',1),
    'countdown for 10 minutes'                       => build_test('600',1),
    'Countdown timer 15 mins'                        => build_test('900',1),
    'Online Countdown Alarm timer 15 mins'           => build_test('900',1),
    'Countdown Alarm timer 15 mins Online'           => build_test('900',1),
    'online start alarm Timer for 10 minutes online' => build_test('600',1),
    'start online CountDown alarm for 10 minutes'    => build_test('600',1),
    'CountDown Timer with 10 minutes'                => build_test('600',1),
    'CountDown Timer at 10 minutes'                  => build_test('600',1),
    '3.5 minute countdown timer'                     => build_test('210',1),
    'begin alarm 30 minutes'                         => build_test('1800',1),
    'set alarm 30 minutes'                           => build_test('1800',1),
    'begin alarm at 30 minutes'                      => build_test('1800',1),
    'set alarm with 30 minutes'                      => build_test('1800',1),
    'set alarm with30 minutes'                       => build_test('1800',1),
    'countdown timer for 77 mins 13 secs'            => build_test('4633',1),
    'start countdown timer for 77 mins 13 secs'      => build_test('4633',1),
    '10 minutes'                                     => build_test('600',1),
    '20 mins'                                        => build_test('1200',1),
    'timer 20 minutes'                               => build_test('1200',1),
    'timer 60 minutes'                               => build_test('3600',1),
    
    # Pomodoro queries
    'pomodoro timer for 10 mins'                     => build_test('600',1),
    'pomodoro countDown for 20 mins'                 => build_test('1200',1),
    'set pomodoro timer for 30 mins'                 => build_test('1800',1),
				
    # Queries with 'a'
    'start a timer for 20 minutes'                   => build_test('1200',1),
    'set a timer to 60 minutes'                      => build_test('3600',1),
    'set a timer of 60 minutes'                      => build_test('3600',1),
    'timer of 5:15 mins'                             => build_test('315',1),  
    
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
    '22 minutes'                 => undef,
    '60 minutes'                 => undef,
    '48 hours'                   => undef,
    'pomodoro tomato'            => undef,
    '48 hours  '                 => undef,
    '5:15 + 32 minutes'          => undef,
    '3:32 - 8 mins'              => undef

);

done_testing;
