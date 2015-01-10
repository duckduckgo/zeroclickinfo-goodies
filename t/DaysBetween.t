#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'days_between';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::DaysBetween)],
    'days between 01/01/2000 01/01/2001' => test_zci(
        'There are 366 days between 01 Jan 2000 and 01 Jan 2001.',
        structured_answer => {
            input     => ['01 Jan 2000', '01 Jan 2001'],
            operation => 'Days between',
            result    => 366
        },
    ),
    'days between 1/1/2000 and 1/1/2001 inclusive' => test_zci(
        'There are 367 days between 01 Jan 2000 and 01 Jan 2001, inclusive.',
        structured_answer => {
            input     => ['01 Jan 2000', '01 Jan 2001'],
            operation => 'Days between, inclusive',
            result    => 367
        },
    ),
    'daysbetween 03/4/2005 and 11/8/2020' => test_zci(
        'There are 5728 days between 04 Mar 2005 and 08 Nov 2020.',
        structured_answer => {
            input     => ['04 Mar 2005', '08 Nov 2020'],
            operation => 'Days between',
            result    => 5728
        },
    ),
    'days_between 3/14/2005 and 1/2/2003' => test_zci(
        'There are 802 days between 02 Jan 2003 and 14 Mar 2005.',
        structured_answer => {
            input     => ['02 Jan 2003', '14 Mar 2005'],
            operation => 'Days between',
            result    => 802
        },
    ),
    'days between 01/31/2000 01/31/2001' => test_zci(
        'There are 366 days between 31 Jan 2000 and 31 Jan 2001.',
        structured_answer => {
            input     => ['31 Jan 2000', '31 Jan 2001'],
            operation => 'Days between',
            result    => 366
        },
    ),
    'days between 01/31/2000 01/31/2001 inclusive' => test_zci(
        'There are 367 days between 31 Jan 2000 and 31 Jan 2001, inclusive.',
        structured_answer => {
            input     => ['31 Jan 2000', '31 Jan 2001'],
            operation => 'Days between, inclusive',
            result    => 367
        },
    ),
    'days between January 31st, 2000 and 31-Jan-2001 inclusive' => test_zci(
        'There are 367 days between 31 Jan 2000 and 31 Jan 2001, inclusive.',
        structured_answer => {
            input     => ['31 Jan 2000', '31 Jan 2001'],
            operation => 'Days between, inclusive',
            result    => 367
        },
    ),
    'days between jan 1 2012 and jan 1 1234' => test_zci(
        "There are 284158 days between 01 Jan 1234 and 01 Jan 2012.",
        structured_answer => {
            input     => ['01 Jan 1234', '01 Jan 2012'],
            operation => 'Days between',
            result    => 284158
        },
    ),
    'days between jan 1 and jan 15 inclusive' => test_zci(
        qr/^There are 15 days between.+inclusive\.$/,
        structured_answer => {
            input     => '-ANY-',
            operation => 'Days between, inclusive',
            result    => 15
        },
    ),
    'days between jan 1 and 15th feb' => test_zci(
        qr/^There are 45 days between.+and 15 Feb [0-9]{4}\.$/,
        structured_answer => {
            input     => '-ANY-',
            operation => 'Days between',
            result    => 45
        },
    ),
    'days between jan 1 2012 and jan 1 123456' => undef,
);

done_testing;
