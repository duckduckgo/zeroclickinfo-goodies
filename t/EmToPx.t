#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'conversion';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::EmToPx )],
    '10 px to em' => test_zci(
        'There are 0.625 em in 10 px (assuming a 16px font size)',
        structured_answer => {
            input     => ['10px', '16px font size'],
            operation => 'Convert to em',
            result    => '0.625em'
        }
    ),
    '1em to px' => test_zci(
        'There are 16 px in 1 em (assuming a 16px font size)',
        structured_answer => {
            input     => ['1em', '16px font size'],
            operation => 'Convert to px',
            result    => '16px'
        }
    ),
    '12.2 px in em assuming a 12.2px font size' => test_zci(
        "There is 1 em in 12.2 px (assuming a 12.2px font size)",
        structured_answer => {
            input     => ['12.2px', '12.2px font size'],
            operation => 'Convert to em',
            result    => '1em'
        }
    ),
    '12.2 px in em assuming a 12.2 font size' => test_zci(
        'There are 0.7625 em in 12.2 px (assuming a 16px font size)',
        structured_answer => {
            input     => ['12.2px', '16px font size'],
            operation => 'Convert to em',
            result    => '0.7625em'
        }
    ),
    '10 px to 10em' => undef,
);

done_testing;
