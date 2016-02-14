#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "days_in_month";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::DaysInMonth )],
    'number of days in january' => test_zci(
        'Number of days in january is 31.',
        structured_answer => {
            input     => ['January'],
            operation => 'Number of days in month',
            result    => 31
        }
    ),
    'how many days are in mar' => test_zci(
        'Number of days in mar is 31.',
        structured_answer => {
            input     => ['Mar'],
            operation => 'Number of days in month',
            result    => 31
        }
    ),
    'Number of days in may' => test_zci(
        'Number of days in may is 30.',
        structured_answer => {
            input     => ['May'],
            operation => 'Number of days in month',
            result    => 30
        }
    ),
    'how many days in Jan' => test_zci(
        'Number of days in Jan is 31.',
        structured_answer => {
            input     => ['Jan'],
            operation => 'Number of days in month',
            result    => 31
        }
    ),
    'number of days in test' => undef,
    'number of days in febtest' => undef,
    'how many test are in' => undef,
    'quantity of days in december' => undef
    
);

done_testing;
