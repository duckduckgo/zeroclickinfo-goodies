#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "ultimate_answer";
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::UltimateAnswer'],

    'what is the answer to the ultimate question of life the universe and everything' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'the answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'what is the answer to my homework question' => undef,
    'why?'                                       => undef,
);

done_testing;
