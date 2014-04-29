#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Time::Piece;

zci answer_type => 'weekdays_between';

# In the output, the abbreviated month will return different results based on
# the user's language settings. This means we need to test against those
# specific values instead of hardcoding in the month abbreviations.
# Abbreviation for January (Jan in english)
my $JAN_ABBREV = Time::Piece->strptime("01", "%m")->strftime("%b");
# Abbreviation for June (Jun in english)
my $JUN_ABBREV = Time::Piece->strptime("06", "%m")->strftime("%b");

ddg_goodie_test(
    [
        'DDG::Goodie::WeekdaysBetween'
    ],

    # Standard work week
    'weekdays between 01/06/2014 01/10/2014' =>
        test_zci("There are 5 weekdays between $JAN_ABBREV 06, 2014 and $JAN_ABBREV 10, 2014."),
    
    # Weekend in the middle
    'weekdays between jan 3, 2014 jan 6, 2014' =>
        test_zci("There are 2 weekdays between $JAN_ABBREV 03, 2014 and $JAN_ABBREV 06, 2014."),

    # Same day
    'weekdays between jan 3, 2014 jan 3, 2014' =>
        test_zci("There is 1 weekday between $JAN_ABBREV 03, 2014 and $JAN_ABBREV 03, 2014."),
    
    # Same day on a weekend
    'weekdays between jan 4, 2014 jan 4, 2014' =>
        test_zci("There are 0 weekdays between $JAN_ABBREV 04, 2014 and $JAN_ABBREV 04, 2014."),
    
    # Invalid input    
    'weekdays between 01/2014 01/2015' => undef,
);

done_testing;
