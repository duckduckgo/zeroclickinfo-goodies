#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'nletterwords';
zci is_cached => 0;

ddg_goodie_test(
        [qw(
                DDG::Goodie::NLetterWords
        )],
        '1 letter words' => test_zci('1 letter words: a, I'),
        '1 char words' => test_zci('1 letter words: a, I'),
        '1 character word' => test_zci('1 letter words: a, I'),
);

done_testing;
