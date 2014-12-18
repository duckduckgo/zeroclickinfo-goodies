#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rand';
zci is_cached => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::RandomNumber )],
    'random number between 12 and 45' => test_zci(
        qr/\d{2} \(random number\)/,
        structured_answer => {
            input     => [12, 45],
            operation => 'random number between',
            result    => qr/^\d{2}$/
        }
    ),
    'random number' => test_zci(qr/\d{1}\.\d+ \(random number\)/,
        structured_answer => {
            input     => [0, 1],
            operation => 'random number between',
            result    => qr/\d{1}\.\d+/,
        }
    ),
    'random day'    => undef,
    'random access' => undef,
);
done_testing
