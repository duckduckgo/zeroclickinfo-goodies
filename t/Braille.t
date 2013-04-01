#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Convert::Braille;
use utf8;

zci is_cached => 1;
zci answer_type => 'braille';

ddg_goodie_test(
        [qw(
                DDG::Goodie::Braille
        )],
        'hello in braille' => test_zci("⠓⠑⠇⠇⠕ (Braille)"),
);

done_testing;
