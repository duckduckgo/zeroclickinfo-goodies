#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'valar_morghulis';
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::ValarMorghulis'],
    'valar morghulis' => test_zci(
        'Valar dohaeris',
        structured_answer => {
            input     => ['Valar morghulis'],
            operation => 'Code phrase',
            result    => 'Valar dohaeris'
        }
    ),
    'what is valar morghulis' => undef,
    'valar morghulis meaning' => undef,
);

done_testing;
