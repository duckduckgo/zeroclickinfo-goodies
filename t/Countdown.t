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

set_fixed_time("2016-04-15T15:31:00");
#set_absolute_time('1970-01-01T00:00:00Z');
#set_fixed_time(CORE::time());

ddg_goodie_test(
    [qw( DDG::Goodie::Countdown )],
    
    'countdown to 10:00:00 am 26th July' => build_test("10:00:00 am 26th July", 8792938000000000, "26 Jul 2016 10:00:00 EDT"),
    'countdown to 10:00:00 am' => build_test("10:00:00 am", 66538000000000, "16 Apr 2016 10:00:00 EDT"),
    'time until 1st June 2016' => build_test("1st June 2016", 4004938000000000, "01 Jun 2016 00:00:00 EDT"),
    'how long until 31st December 2016' => build_test("31st December 2016", 22411738000000000, "31 Dec 2016 00:00:00 EST"),
    'how long until 1st May 12:00:00 pm' => build_test("1st May 12:00:00 pm", 1369738000000000, "01 May 2016 12:00:00 EDT"),
    'how long until 01:00:00 pm tomorrow' => build_test("01:00:00 pm tomorrow", 163738000000000, "17 Apr 2016 13:00:00 EDT"),
    'how long until 01:00:00 am today' => build_test("01:00:00 am today", 34138000000000, "16 Apr 2016 01:00:00 EDT"),
    
    #invalid
    'how long until 01:00:00 am yesterday' => undef
);

done_testing;
