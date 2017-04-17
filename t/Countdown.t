#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::MockTime qw( :all );
use DDG::Test::Goodie;
use DDG::Test::Location;
use DateTime;

zci answer_type => "countdown";
zci is_cached   => 1;

my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

sub build_structured_answer {
    my ($remainder, $initialDifference, $date_string, $output_string) = @_;
    
    return $initialDifference,
        structured_answer => {
            data => {
                remainder      => $remainder,
                countdown_to   => $output_string,
                goodie_version => $goodieVersion,
                input_date     => $date_string
            },
            templates => {
                group => "text",
                options => {
                    title_content => 'DDH.countdown.countdown'
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)); }

set_fixed_time("2016-04-15T15:31:02Z");

ddg_goodie_test(
    [qw( DDG::Goodie::Countdown )],
    
    'time until 2016-06-01'     => build_test("2016-06-01", 4019338, "2016-06-01T00:00:00", "June 01, 2016, 12:00:00 AM"),
    'how long until 2016-12-31' => build_test("2016-12-31", 22426138, "2016-12-31T00:00:00", "December 31, 2016, 12:00:00 AM"),
    'countdown to tomorrow'     => build_test("tomorrow", 86400, "2016-04-16T11:31:02", "April 16, 2016, 11:31:02 AM"),
    
    ## Currently these do not trigger, uncomment after PR #2810 is merged 
    #'countdown to 10:00:00 am 26th July'  => build_test("10:00:00 am 26th July", 8807338000000000, "2016-07-26T10:00:00", "26 Jul 2016 10:00:00 AM"),
    #'countdown to 10:00:00 am'            => build_test("10:00:00 am", 80938000000000 , "2016-04-16T10:00:00", "16 Apr 2016 10:00:00 AM"),
    #'time until 1st May 12:00:00 pm'      => build_test("1st May 12:00:00 pm",1384138000000000 , "2016-05-01T12:00:00", "01 May 2016 12:00:00 PM"),
    #'how long until 01:00:00 pm tomorrow' => build_test("01:00:00 pm tomorrow", 91738000000000, "2016-04-16T13:00:00", "16 Apr 2016 01:00:00 PM"),
    #'how long until 01:00:00 am today'    => build_test("01:00:00 am today", 48538000000000, "2016-04-16T01:00:00", "16 Apr 2016 01:00:00 AM"),
    
    #invalid
    'how long until 01:00:00 am yesterday' => undef,    
);

done_testing;
