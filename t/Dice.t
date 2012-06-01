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
        'throw dice' => test_zci(qr/^\d \d$/),
        "roll 5 dice" => test_zci(qr/\d \d \d \d \d/),
        "throw die" => test_zci(qr/^\d$/),
        "roll 2d6" => test_zci(qr/^\d \+ \d = \d+$/),
        "roll 3d12 + 4" => test_zci(qr/^\d{1,2} \+ \d{1,2} \+ \d{1,2} \+ \d{1,2} = \d{1,2}$/),
        "throw 1d20" => test_zci(qr/\d{1,2}$/),
        "roll 3d8 - 8" => test_zci(qr/^\d \+ \d \+ \d - \d = \d+$/),
        "roll d20" => test_zci(qr/^\d{1,2}$/),
);

done_testing;
