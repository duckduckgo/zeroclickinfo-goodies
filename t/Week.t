#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "week";
zci is_cached => 1;

# Output verified with UNIX cal program

ddg_goodie_test(
        [qw(
                DDG::Goodie::Week
        )],

        "what week is this?" => test_zci(
            qr/We are in currently in the \d+\w+ week of \d+\./,
            html => qr:We are in currently in the \d+<sup>\w+</sup> week of \d+\.:),

        "what is the current week" => test_zci(
            qr/We are in currently in the \d+\w+ week of \d+\./,
            html => qr:We are in currently in the \d+<sup>\w+</sup> week of \d+\.:),

        "what's   the current week? " => test_zci(
            qr/We are in currently in the \d+\w+ week of \d+\./,
            html => qr:We are in currently in the \d+<sup>\w+</sup> week of \d+\.:),

        "whats the current week of the year" => test_zci(
            qr/We are in currently in the \d+\w+ week of \d+\./,
            html => qr:We are in currently in the \d+<sup>\w+</sup> week of \d+\.:),

        "what was the 5th week of this year" => test_zci(
            qr/The \d+\w+ week of \d+ began on January \d+\w+\./,
            html => qr:The \d+<sup>\w+</sup> week of \d+ began on January \d+<sup>\w+</sup>\.:),

        "what was the 43rd week of 1984" => test_zci(
            "The 43rd week of 1984 began on October 22nd.",
            html => "The 43<sup>rd</sup> week of 1984 began on October 22<sup>nd</sup>."),

        "what was the 8th week of 1956" => test_zci(
            "The 8th week of 1956 began on February 20th.",
            html => "The 8<sup>th</sup> week of 1956 began on February 20<sup>th</sup>."),

        "what was the 21st week of 1987" => test_zci(
            "The 21st week of 1987 began on May 18th.",
            html => "The 21<sup>st</sup> week of 1987 began on May 18<sup>th</sup>."),
        'what was the 5th week of 1944' => test_zci(
            'The 5th week of 1944 began on January 31st.',
            html => 'The 5<sup>th</sup> week of 1944 began on January 31<sup>st</sup>.'
        ),
);

done_testing;
