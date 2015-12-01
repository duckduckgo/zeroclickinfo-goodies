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
        "Mean: 2; Median: 2; Root Mean Square: 2.16024689946929",
        structured_answer => {
            id => 'average',
            name => 'Math',
            data => {
                mean => 2,
                median => 2,
                rms => 2.16024689946929
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.average.content'
                }
            }
        }
    ),
	'mean 1, 2, 3' => test_zci(
        "Mean: 2; Median: 2; Root Mean Square: 2.16024689946929",
        structured_answer => {
            id => 'average',
            name => 'Math',
            data => {
                mean => 2,
                median => 2,
                rms => 2.16024689946929
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.average.content'
                }
            }
        }
    ),
	'root mean square 1,2,3' => test_zci(
        "Mean: 2; Median: 2; Root Mean Square: 2.16024689946929", 
        structured_answer => {
            id => 'average',
            name => 'Math',
            data => {
                mean => 2,
                median => 2,
                rms => 2.16024689946929
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.average.content'
                }
            }
        }
    ),
    "average 12 45 78 1234.12" => test_zci(
        "Mean: 342.28; Median: 61.5; Root Mean Square: 618.72958034993", 
        structured_answer => {
            id => 'average',
            name => 'Math',
            data => {
                mean => 342.28,
                median => 61.5,
                rms => 618.72958034993
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.average.content'
                }
            }
        }
    ),
    "average 12, 45, 78, 1234.12" => test_zci(
        "Mean: 342.28; Median: 61.5; Root Mean Square: 618.72958034993", 
        structured_answer => {
            id => 'average',
            name => 'Math',
            data => {
                mean => 342.28,
                median => 61.5,
                rms => 618.72958034993
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.average.content'
                }
            }
        }
    ),
    "average 12;45;78;1234.12" => test_zci(
        "Mean: 342.28; Median: 61.5; Root Mean Square: 618.72958034993", 
        structured_answer => {
            id => 'average',
            name => 'Math',
            data => {
                mean => 342.28,
                median => 61.5,
                rms => 618.72958034993
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.average.content'
                }
            }
        }
    ),
    'average 12, 45, 78, 1234' => test_zci(
        'Mean: 342.25; Median: 61.5; Root Mean Square: 618.669742269654', 
        structured_answer => {
            id => 'average',
            name => 'Math',
            data => {
                mean => 342.25,
                median => 61.5,
                rms => 618.669742269654
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.average.content'
                }
            }
        }
    ),
    'avg 1,2,3' => test_zci(
        'Mean: 2; Median: 2; Root Mean Square: 2.16024689946929', 
        structured_answer => {
            id => 'average',
            name => 'Math',
            data => {
                mean => 2,
                median => 2,
                rms => 2.16024689946929
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.average.content'
                }
            }
        }
    ),

    #Should not trigger
    'average temperature philadelphia 2012 january' => undef,
);

done_testing;

