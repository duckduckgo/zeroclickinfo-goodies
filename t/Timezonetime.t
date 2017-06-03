#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockTime qw(:all);
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'timezonetime';
zci is_cached   => 1;

my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my ($time, $timezone, $daylightSaving) = @_;
    
    return "$time $timezone $daylightSaving",
        structured_answer => {
            data => {
                title    => "$time $timezone",
                subtitle => "$daylightSaving",
                # image => 'http://website.com/image.png',
            },

            templates => {
                group => 'text',
                # options => {
                #
                # }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

set_fixed_time('2017-06-03T09:36:53Z');

ddg_goodie_test(
    ['DDG::Goodie::Timezonetime'],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'time in pst'  => build_test("02:36:53", "PST", "PST is in daylight saving"),
    'ist now time' => build_test("15:06:53", "IST", "IST is not in daylight saving"),
    'time now cst' => build_test("04:36:53", "CST", "CST is in daylight saving"),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'time in pstt' => undef,
);

done_testing;
