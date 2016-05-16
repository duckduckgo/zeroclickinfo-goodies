#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'nletterwords';
zci is_cached => 0;

ddg_goodie_test(
        [qw(
                DDG::Goodie::NLetterWords
        )],
        '1 letter words' => test_zci('Random 1 letter words: a, I.'),
        '1 char words' => test_zci('Random 1 letter words: a, I.'),
        '1 character word' => test_zci('Random 1 letter words: a, I.'),
        'one letter words' => test_zci('Random 1 letter words: a, I.'),
        '5 letter words' => test_zci(re(qr/Random 5 letter words: ((\w){5},? ?){30}/)),
        '12 character word' => test_zci(re(qr/Random 12 letter words: ((\w){12},? ?){30}/)),
);

done_testing;
