#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "scramble";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Scramble )],
    'scramble of filter' => test_zci(
        'Scramble of filter',
        structured_answer => {
            id => 'scramble',
            name => 'Words & games',

            data => '-ANY-',

            templates => {
                group => "text"
            }
        },
    ),
    'scramble of'              => undef,
    'Scramble for'            => undef,
    'Scrambles for ""'         => undef,
    'Scrambles for "867-5309"' => undef,
);

done_testing;
