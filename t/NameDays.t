#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "name_days_w25";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::NameDays )],
    'name day mieszko' => test_zci(' 1 Jan'),
    'maria imieniny' => test_zci('23 Jan,  2 Feb, 11 Feb, 25 Mar, 14 Apr, 26 Apr, 28 Apr,  3 May, 24 May, 25 May, 29 May,  2 Jun, 13 Jun, 27 Jun,  2 Jul, 16 Jul, 17 Jul, 22 Jul, 29 Jul,  2 Aug,  4 Aug,  5 Aug, 15 Aug, 22 Aug, 26 Aug,  8 Sep, 12 Sep, 15 Sep, 24 Sep,  7 Oct, 11 Oct, 16 Nov, 21 Nov,  8 Dec, 10 Dec'),
    '3 June name day' => test_zci('Konstantyn Leszek Paula Tamara'),
    'namedays dec 30' => test_zci('Dawid Eugeniusz Katarzyna Uniedrog'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'name day' => undef,
);

done_testing;
