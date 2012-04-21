#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'days_between';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::DaysBetween
        )],
        'days between 01/01/2000 01/01/2001' => test_zci('366 days between'),
        'days between 01/01/2000 01/01/2001 inclusive' => test_zci('367 days between'),
);

done_testing;
