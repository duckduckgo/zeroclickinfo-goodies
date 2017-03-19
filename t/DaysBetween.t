#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'days_between';
zci is_cached   => 0;

ddg_goodie_test(
    [
        'DDG::Goodie::DaysBetween'
    ],

    'days between 19.1.2000 and 20.1.2000' => test_zci(
        'plain text response',
        structured_answer => {
               data => {
                 title => "Date Math",
                   },
               templates => {}
           },
    )
);

done_testing;
