#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'percent_error';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::PercentError
    )],
    '%err 41 43' => test_zci(
        'Accepted: 41 Experimental: 43 Error: 4.8780487804878%', 
        structured_answer => {
            data => {
                title => "Error: 4.8780487804878%",
                subtitle => "Accepted: 41 Experimental: 43",
            },
            templates => {
                group => 'text',
            }
        }
    ),
    'percent-error 34.5 35' => test_zci(
        'Accepted: 34.5 Experimental: 35 Error: 1.44927536231884%', 
        structured_answer => {
            data => {
                title => "Error: 1.44927536231884%",
                subtitle => "Accepted: 34.5 Experimental: 35",
            },
            templates => {
                group => 'text',
            }
        }
    ),
    "%-error 2.88 2.82" => test_zci(
        "Accepted: 2.88 Experimental: 2.82 Error: 2.08333333333334%",
        structured_answer => {
            data => {
                title => "Error: 2.08333333333334%",
                subtitle => "Accepted: 2.88 Experimental: 2.82",
            },
            templates => {
                group => 'text',
            }
        }
    ),
    "% error 45.12 45.798" => test_zci(
        "Accepted: 45.12 Experimental: 45.798 Error: 1.50265957446809%", 
        structured_answer => {
            data => {
                title => "Error: 1.50265957446809%",
                subtitle => "Accepted: 45.12 Experimental: 45.798",
            },
            templates => {
                group => 'text',
            }
        }
    ),
    "percent err -45.12 -50.00" => test_zci(
        "Accepted: -45.12 Experimental: -50.00 Error: 10.8156028368794%",
        structured_answer => {
            data => {
                title => "Error: 10.8156028368794%",
                subtitle => "Accepted: -45.12 Experimental: -50.00",
            },
            templates => {
                group => 'text',
            }
        }
    ),
    "percent-error 1;1" => test_zci(
        "Accepted: 1 Experimental: 1 Error: 0%", 
        structured_answer => {
            data => {
                title => "Error: 0%",
                subtitle => "Accepted: 1 Experimental: 1",
            },
            templates => {
                group => 'text',
            }
        }    ),
);

done_testing;
