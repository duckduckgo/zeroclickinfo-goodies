#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'stopwatch';

ddg_goodie_test(
    [
        'DDG::Goodie::Stopwatch'
    ],
    'stopwatch' =>
        test_zci(
            'Stopwatch', html => qr/00:00:00.000/
        ),
	'blahblah stopwatch' => undef, 
);

done_testing;
