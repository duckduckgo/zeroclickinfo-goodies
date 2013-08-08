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
        'throw dice' => test_zci(qr/^., . \(random\)$/, html => qr//),
        "roll 5 dice" => test_zci(qr/., ., ., ., . \(random\)$/, html => qr//),
        "throw die" => test_zci(qr/^. \(random\)$/, html => qr//),
        "roll 2d6" => test_zci(qr/^\d (\+|-) \d = \d+ \(random\)$/),
        "roll 3d12 + 4" => test_zci(qr/^\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d{1,2} \(random\)$/),
        "throw 1d20" => test_zci(qr/\d{1,2} \(random\)$/),
        "roll 3d8 - 8" => test_zci(qr/^\d (\+|-) \d (\+|-) \d (\+|-) \d = -?\d+ \(random\)$/),
        "roll d20" => test_zci(qr/^\d{1,2} \(random\)$/),
        "roll 4d6-l" => test_zci(qr/^([1-6] \+ ){3}[1-6] - [1-6] = \d{1,2} \(random\)$/),
);

done_testing;
