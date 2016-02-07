#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "ultimate_answer";
zci is_cached   => 1;

my $answer = 'Forty-two';
my $structuredAnswer = {
    id        => 'ultimate_answer',
    name      => 'Answer',
    data      => {
        title      => $answer,
        subtitle   => 'The Answer to the Ultimate Question of Life, the Universe, and Everything.'
    },
    meta      => {
        sourceName => 'Wikipedia',
        sourceUrl  => 'https://en.wikipedia.org/wiki/Phrases_from_The_Hitchhiker%27s_Guide_to_the_Galaxy#Answer_to_the_Ultimate_Question_of_Life.2C_the_Universe.2C_and_Everything_.2842.29'
    },
    templates => {
        group      => 'text'
    }
};

ddg_goodie_test(
    ['DDG::Goodie::UltimateAnswer'],

    'what is the answer to life the universe and everything' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'What is the Answer to Life the Universe and Everything' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'what is the answer to life the universe and everything?' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'answer to life the universe and everything' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'meaning of life the universe and everything' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'ultimate answer' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'Ultimate Answer' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'what is the ultimate answer' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'what is the ultimate answer?' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'what is the ultimate answer to life the universe and everything' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'answer to the ultimate question' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'Answer to the Ultimate Question' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'Answer to the Ultimate Question of Life, the Universe, and Everything' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'The Answer to the Ultimate Question of Life, the Universe, and Everything' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'what is the answer to the ultimate question' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'what is the answer to the ultimate question?' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
    ),
    'what is the answer to the ultimate question of life the universe and everything' => test_zci(
        $answer,
        structured_answer => $structuredAnswer
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
