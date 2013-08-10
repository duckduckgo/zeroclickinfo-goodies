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

        # "week current" => test_zci("We are in week number 32"),

        # "week 6" => test_zci("Week 6 started on 2-4 in 2013"),

        "week 43 1984" => test_zci("Week 43 started on 10-22 of 1984"),

        "week 8 1956" => test_zci("Week 8 started on 2-20 of 1956"),

        "week 21 1987" => test_zci("Week 21 started on 5-18 of 1987"),
);

done_testing;
