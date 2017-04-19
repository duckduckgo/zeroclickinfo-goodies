#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "deep_thought";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::DeepThought )],

    'ultimate question of life the universe and everything' => test_zci(
        42,
        structured_answer => {
            input     => [],
            operation => 'The Answer to the Ultimate Question of Life, The Universe, and Everything',
            result    => 42
        }
    ),

    'answer to life the universe and everything' => test_zci(
        42,
        structured_answer => {
            input     => [],
            operation => 'The Answer to the Ultimate Question of Life, The Universe, and Everything',
            result    => 42
        }
    ),
    
    'life the universe and everything answer' => test_zci(
        42,
        structured_answer => {
            input     => [],
            operation => 'The Answer to the Ultimate Question of Life, The Universe, and Everything',
            result    => 42
        }
    ),
    
    'life the universe and everything question' => test_zci(
        42,
        structured_answer => {
            input     => [],
            operation => 'The Answer to the Ultimate Question of Life, The Universe, and Everything',
            result    => 42
        }
    ),
    
    'life the universe and everything' => undef,
);

done_testing;
