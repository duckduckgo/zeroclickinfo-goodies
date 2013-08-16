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

        "what is the current week" =>
          test_zci(qr/We are in currently in the \d+\w+ week of \d+/),

        "what's the current week?" =>
          test_zci(qr/We are in currently in the \d+\w+ week of \d+/),

        "whats the current week of the year" =>
          test_zci(qr/We are in currently in the \d+\w+ week of \d+/),

        "what was the 5th week of this year" =>
          test_zci(qr/The \d+\w+ week of \d+ began on January \d+\w+/),

        "what was the 43rd week of 1984" =>
          test_zci("The 43rd week of 1984 began on October 22nd"),

        "what was the 8th week of 1956" =>
          test_zci("The 8th week of 1956 began on February 20th"),

        "what was the 21st week of 1987" =>
          test_zci("The 21st week of 1987 began on May 18th"),
);

done_testing;
