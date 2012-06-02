#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'chars';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Morse
        )],
        'morse ... --- ...' => test_zci('Morse code: SOS'),
        'morse SOS' =>
          test_zci('Morse code: ... --- ...'),
        'morse code SOS' =>
          test_zci('Morse code: ... --- ...'),
        'SOS morse' =>
          test_zci('Morse code: ... --- ...'),
        'SOS morse code' =>
          test_zci('Morse code: ... --- ...'),
        'morse hello, duck' =>
          test_zci('Morse code: .... . .-.. .-.. --- --..--  -.. ..- -.-. -.-'),
        'morse code hello, duck' =>
          test_zci('Morse code: .... . .-.. .-.. --- --..--  -.. ..- -.-. -.-'),
);

done_testing;
