#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'current_time';
zci is_cached => 1;

ddg_goodie_test(
    ['DDG::Goodie::CurrentTime'],
    'current time in EST' =>
        test_zci('current time in EST.'),
    'time in London' =>
    	test_zci('time in London'),
    'tokyo time' =>
    	test_zci('tokyo time'),
    'what time is it in istanbul' =>
    	test_zci('what time is it in istanbul'),
    'current time new york' =>
    	test_zci('current time new york'),
    'prague time right now' =>
    	test_zci('prague time right now'),
    'what\'s the time in Berlin, Germany?' =>
    	test_zci('what\'s the time in Berlin, Germany?'),
    'hong kong local time' =>
    	test_zci('hong kong local time'),
    'current time in Paris' =>
    	test_zci('current time in Paris')
);

done_testing;
