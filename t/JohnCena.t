#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "john_cena";
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::JohnCena'],

    'who is champ' => test_zci(
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
