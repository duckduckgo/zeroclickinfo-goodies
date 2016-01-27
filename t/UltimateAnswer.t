#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "ultimate_answer";
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::UltimateAnswer'],

    'what is the answer to life the universe and everything' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'The answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'question life the universe and everything' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'The answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'answer to life the universe and everything' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'The answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'what is life the universe and everything' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'The answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'meaning of life the universe and everything' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'The answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'ultimate answer' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'The answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'what is the ultimate answer' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'The answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'what is the ultimate answer to life the universe and everything' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'The answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'answer to the ultimate question' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'The answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'what is the answer to the ultimate question' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'The answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'what is the answer to the ultimate question of life the universe and everything' => test_zci(
        'Forty-two',
        structured_answer => {
            input     => [],
            operation => 'The answer to the ultimate question of life, the universe and everything',
            result    => 'Forty-two',
        }
    ),
    'life the universe and everything'           => undef,
    'life the universe and everything 42'        => undef,
    'blah life the universe and everything'      => undef,
    'ultimate answer to kings'                   => undef,
    'blah ultimate answer'                       => undef,
    'answer to the ultimate question of life'    => undef,
    'blah answer to the ultimate question'       => undef,
    'what is the answer to my homework question' => undef,
    'why?'                                       => undef,
);

done_testing;
