#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::MockTime qw( :all );
use DDG::Test::Goodie;
use DDG::Test::Location;

zci answer_type => "countdown";
zci is_cached   => 1;

sub build_structured_answer {
    my ($remainder, $initialDifference, $output_string) = @_;
    
    return $initialDifference,
        structured_answer => {
            data => {
                remainder => $remainder,
                difference => $initialDifference,
                countdown_to => $output_string
            },
            templates => {
                group => "text",
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)); }

set_fixed_time("2016-04-15T15:31:02Z");

ddg_goodie_test(
    [qw( DDG::Goodie::Countdown )],
    
    'time until 1st June 2016'            => build_test("1st June 2016", 4019338 , "01 Jun 2016 00:00:00 EDT"),
    'how long until 31st December 2016'   => build_test("31st December 2016", 22426138, "31 Dec 2016 00:00:00 EST"),
    'countdown to tomorrow'               => build_test("tomorrow", 86400, "16 Apr 2016 11:31:02 EDT"),
    
    #invalid
    'how long until 01:00:00 am yesterday' => undef,
    'countdown to 10:00:00 am 26th July'   => undef,
    'countdown to 10:00:00 am'             => undef,
    'time until 1st May 12:00:00 pm'       => undef,
    'how long until 01:00:00 pm tomorrow'  => undef,
    'how long until 01:00:00 am today'     => undef,
);

done_testing;
