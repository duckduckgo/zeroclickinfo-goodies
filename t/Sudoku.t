#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sudoku';
zci is_cached => 0;

ddg_goodie_test(
    [
        'DDG::Goodie::Sudoku'
    ],
    "sudoku" => test_zci(
        qr/^[0-9_].*[0-9_]$/s,
        structured_answer => {
            id => 'sudoku',
            name => 'Games',
            data => '-ANY-',
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
        qr/^[0-9_].*[0-9_]$/s,
        structured_answer => {
            id => 'sudoku',
            name => 'Games',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.sudoku.content'
                }
            }
        }
    ),,
    "easy sudoku" => test_zci(
        qr/^[0-9_].*[0-9_]$/s,
        structured_answer => {
            id => 'sudoku',
            name => 'Games',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.sudoku.content'
                }
            }
        }
    ),,
    "sudoku hard" => test_zci(
        qr/^[0-9_].*[0-9_]$/s,
        structured_answer => {
            id => 'sudoku',
            name => 'Games',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.sudoku.content'
                }
            }
        }
    ),,
    "generate sudoku" => test_zci(
        qr/^[0-9_].*[0-9_]$/s,
        structured_answer => {
            id => 'sudoku',
            name => 'Games',
            data => '-ANY-',
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
        qr/[0-9_].*[0-9_]$/s,
        structured_answer => {
            id => 'sudoku',
            name => 'Games',
            data => '-ANY-',
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
