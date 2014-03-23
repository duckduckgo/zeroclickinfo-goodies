#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'atbash';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Atbash
        )],
        'atbash test' => test_zci('Atbash: gvhg'),
        'atbash This is a test' => test_zci('Atbash: Gsrh rh z gvhg'),
        'atbash Gonna party like it\'s 1999!' => test_zci('Atbash: Tlmmz kzigb orpv rg\'h 1999!'),
        'Atbash abcdefghijklmnopqrstuvwxyz' => test_zci('Atbash: zyxwvutsrqponmlkjihgfedcba'),
        'atbash hello' => test_zci('Atbash: svool'),
        'atbash svool' => test_zci('Atbash: hello'),
);

done_testing;
