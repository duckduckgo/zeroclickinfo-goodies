#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Convert::Braille;

zci is_cached => 1;
zci answer_type => 'braille';

ddg_goodie_test(
        [qw(
                DDG::Goodie::Braille
        )],
        'hello in braille' => test_zci("\x{2813}\x{2811}\x{2807}\x{2807}\x{2815} (Braille)"),
);

done_testing;
