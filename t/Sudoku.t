#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'sudoku';
zci is_cached => 0;

ddg_goodie_test(
	[
		'DDG::Goodie::Sudoku'
	],
	"sudoku" => test_zci(
        'Sudoku',
		structured_answer => {
            data => {
                title => 'Sudoku easy',
                level => 'easy'
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.sudoku.content'
                }
            }
        }
	),
	"play sudoku" => test_zci(
        'Sudoku',
		structured_answer => {
            data => {
                title => 'Sudoku easy',
                level => 'easy'
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.sudoku.content'
                }
            }
        }
	),
	"easy sudoku" => test_zci(
        'Sudoku',
		structured_answer => {
            data => {
                title => 'Sudoku easy',
                level => 'easy'
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.sudoku.content'
                }
            }
        }
	),
	"sudoku hard" => test_zci(
        'Sudoku',
		structured_answer => {
            data => {
                title => 'Sudoku hard',
                level => 'hard'
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.sudoku.content'
                }
            }
        }
	),
	"generate sudoku" => test_zci(
        'Sudoku',
		structured_answer => {
            data => {
                title => 'Sudoku easy',
                level => 'easy'
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.sudoku.content'
                }
            }
        }
	),
	"sudoku party" => undef,
	"sudoku toys" => undef,
    'sudoku easy' => test_zci(
        'Sudoku',
		structured_answer => {
            data => {
                title => 'Sudoku easy',
                level => 'easy'
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.sudoku.content'
                }
            }
        }
    ),
);

done_testing;
