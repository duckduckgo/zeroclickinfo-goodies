#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

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

    'what is the current week of the year?' => test_zci(@current_week),
    "what week is this?" => test_zci(@current_week),
    "what is the current week" => test_zci(@current_week),
    "what's   the current week? " => test_zci(@current_week),
    "whats the current week of the year" => test_zci(@current_week),

    "what was the 5th week of this year" => test_zci(
        qr/The \d{1,2}\w{2} week of \d{4} began on January \d{1,2}\w{2}\./,
        structured_answer => {
            input     => [],
            operation => "Assuming the week starts on Monday",
            result    => qr/The \d{1,2}\w{2} week of \d{4} began on January \d{1,2}\w{2}\./,
        }
    ),

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
);

done_testing;
