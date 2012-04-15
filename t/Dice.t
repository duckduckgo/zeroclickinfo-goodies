#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'dice_roll';
zci is_cached => 0;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Dice
        )],
        'throw dice' => test_zci(qr/\d \d/),
);

done_testing;
