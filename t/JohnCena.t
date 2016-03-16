#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "john_cena";
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::JohnCena'],

    'what is the answer to the ultimate question of life the universe and everything' => test_zci(
        'JOHN CENA',
        structured_answer => {
            input     => [],
            operation => 'YOUR TIME IS UP, MY TIME IS NOW',
            result    => 'JOHN CENA',
        }
    ),
    'who champ' => undef,
    'wrestler meme' => undef,
);

done_testing;