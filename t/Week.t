#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

zci answer_type => "week";
zci is_cached => 1;

my @current_week = (
    qr/We are currently in the \d{1,2}\w{2} week of \d{4}./,
    structured_answer => {
        input     => [],
        operation => 'Assuming the week starts on Monday',
        result    => qr/We are currently in the \d{1,2}\w{2} week of \d{4}./,
    });


ddg_goodie_test(
    ['DDG::Goodie::Week'],

    # Current Week Queries
    'what is the current week of the year?' => test_zci(@current_week),
    "what week is this?" => test_zci(@current_week),
    "what is the current week" => test_zci(@current_week),
    "what's   the current week? " => test_zci(@current_week),
    "whats the current week of the year" => test_zci(@current_week),

    "what was the 43rd week of 1984" => test_zci(
        "The 43rd week of 1984 began on October 22nd.",
        structured_answer => {
            input     => [],
            operation => 'Assuming the week starts on Monday',
            result    => "The 43rd week of 1984 began on October 22nd.",
        }
    ),

    "what was the 8th week of 1956" => test_zci(
        "The 8th week of 1956 began on February 20th.",
        structured_answer => {
            input     => [],
            operation => 'Assuming the week starts on Monday',
            result    => "The 8th week of 1956 began on February 20th.",
        }
    ),

    "what was the 21st week of 1987" => test_zci(
        "The 21st week of 1987 began on May 18th.",
        structured_answer => {
            input     => [],
            operation => 'Assuming the week starts on Monday',
            result    => "The 21st week of 1987 began on May 18th.",
        }
    ),

    'what was the 5th week of 1944' => test_zci(
        "The 5th week of 1944 began on January 31st.",
        structured_answer => {
            input     => [],
            operation => 'Assuming the week starts on Monday',
            result    => "The 5th week of 1944 began on January 31st.",
        }
    ),
    'what was the 5th week of 0000' => undef,
    "what was the 0 week of 2011" => undef,
    "what was the 99th week of 2011" => undef,
);

set_fixed_time('2014-01-01T00:00:00');
ddg_goodie_test(
    ['DDG::Goodie::Week'],
    'when is the 8th week of 2015' => test_zci(
        "The 8th week of 2015 begins on February 16th.",
        structured_answer => {
            input     => [],
            operation => 'Assuming the week starts on Monday',
            result    => "The 8th week of 2015 begins on February 16th.",
        }
    )
);
restore_time();

set_fixed_time('2015-07-31T00:00:00');
ddg_goodie_test(
    ['DDG::Goodie::Week'],
    'when is the 8th week of 2015' => test_zci(
        "The 8th week of 2015 began on February 16th.",
        structured_answer => {
            input     => [],
            operation => 'Assuming the week starts on Monday',
            result    => "The 8th week of 2015 began on February 16th.",
        },
    ),
    # Nth Week Queries
    "what was the 5th week of this year" => test_zci(
        qr/The \d{1,2}\w{2} week of \d{4} (begins|began) on January \d{1,2}\w{2}\./,
        structured_answer => {
            input     => [],
            operation => "Assuming the week starts on Monday",
            result    => qr/The \d{1,2}\w{2} week of \d{4} (begins|began) on January \d{1,2}\w{2}\./,
        }
    )
);
restore_time();

done_testing;