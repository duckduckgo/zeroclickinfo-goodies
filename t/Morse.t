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
        'morse ... --- ...' => test_zci('Morse: SOS'),
        'morse hello, duck' =>
          test_zci('Morse: .... . .-.. .-.. --- --..--  -.. ..- -.-. -.-'),
);

done_testing;
