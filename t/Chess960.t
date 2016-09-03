#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'chess960_position';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Chess960
	)],
    'chess960 random' => test_zci(
        'Chess 960',
        structured_answer => {
            data => ignore(),
            templates => {
                group => "text",
                item => 0,
                options => {
                    content => "DDH.chess960.content"
                },
            }
        }
    )
);

done_testing;
