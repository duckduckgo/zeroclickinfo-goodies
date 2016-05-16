#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'phonetic';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Phonetic
        )],
        'phonetic what duck' => test_zci('Phonetic: Whiskey-Hotel-Alfa-Tango Delta-Uniform-Charlie-Kilo'),
        'phonetic through yonder' => test_zci('Phonetic: Tango-Hotel-Romeo-Oscar-Uniform-Golf-Hotel Yankee-Oscar-November-Delta-Echo-Romeo'),
        'phonetic window quacks' => test_zci('Phonetic: Whiskey-India-November-Delta-Oscar-Whiskey Quebec-Uniform-Alfa-Charlie-Kilo-Sierra'),
        'phonetic Who are you?' => test_zci('Phonetic: Whiskey-Hotel-Oscar Alfa-Romeo-Echo Yankee-Oscar-Uniform')
);

done_testing;
