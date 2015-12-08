#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'average';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Average
	)],
	'1 2 3 avg' => test_zci(
        "Mean: 2",
        structured_answer => {
            input     => ['1 2 3'],
            operation => "Mean of",
            result    => '2',
        }
    ),
	'mean 1, 2, 3' => test_zci(
        "Mean: 2",
        structured_answer => {
            input     => ['1 2 3'],
            operation => "Mean of",
            result    => '2',
        }
    ),
	'root mean square 1,2,3' => test_zci(
        "Root Mean Square: 2.16024689946929", 
        structured_answer => {
            input     => ['1 2 3'],
            operation => "Root Mean Square of",
            result    => '2.16024689946929',
        }
    ),
    'rms 1,2,3' => test_zci(
        "Root Mean Square: 2.16024689946929", 
        structured_answer => {
            input     => ['1 2 3'],
            operation => "Root Mean Square of",
            result    => '2.16024689946929',
        }
    ),
    "average 12 45 78 1234.12" => test_zci(
        "Mean: 342.28", 
        structured_answer => {
            input     => ['12 45 78 1234.12'],
            operation => "Mean of",
            result    => '342.28',
        }
    ),
    "average 12, 45, 78, 1234.12" => test_zci(
        "Mean: 342.28", 
        structured_answer => {
            input     => ['12 45 78 1234.12'],
            operation => "Mean of",
            result    => '342.28',
        }
    ),
    "average 12;45;78;1234.12" => test_zci(
        "Mean: 342.28", 
        structured_answer => {
            input     => ['12 45 78 1234.12'],
            operation => "Mean of",
            result    => '342.28',
        }
    ),
    'average 12, 45, 78, 1234' => test_zci(
        'Mean: 342.25',  
        structured_answer => {
            input     => ['12 45 78 1234'],
            operation => "Mean of",
            result    => '342.25',
        }
    ),
    'median 1,2,3' => test_zci(
        'Median: 2', 
        structured_answer => {
            input     => ['1 2 3'],
            operation => "Median of",
            result    => '2',
        }
    ),

    #Should not trigger
    'average temperature philadelphia 2012 january' => undef,
);

done_testing;

