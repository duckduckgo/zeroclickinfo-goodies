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
            id        => 'john_cena',
            name      => 'Answer',
            data      => {
                title      => 'JOHN CENA',
                subtitle   => 'YOUR TIME IS UP, MY TIME IS NOW'
            },
            meta      => {
                sourceName => 'Wikipedia',
                sourceUrl  => 'https://en.wikipedia.org/wiki/John_Cena'
            },
            templates => {
                group      => 'text'
            }
        }
    ),
    'who champ' => undef,
    'famous wrestler' => undef,
);

done_testing;
