#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'dice_roll';
zci is_cached => 0;

my $header = "Random Dice Roll<br/>";

ddg_goodie_test(
        [qw(
                DDG::Goodie::Dice
        )],
        'throw dice' => test_zci(qr/^., .$/, html => qr//),
        "roll 5 dice" => test_zci(qr/., ., ., ., .$/, html => qr//),
        "throw die" => test_zci(qr/^.$/, html => qr//),
        "roll 2d6" => test_zci(qr/^$header\d (\+|-) \d = \d+$/),
        "roll 3d12 + 4" => test_zci(qr/^$header\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d{1,2}$/),
        "throw 1d20" => test_zci(qr/^$header\d{1,2}$/),
        "roll 3d8 - 8" => test_zci(qr/^$header\d (\+|-) \d (\+|-) \d (\+|-) \d = -?\d+$/),
        "roll d20" => test_zci(qr/^$header\d{1,2}$/),
        "roll 4d6-l" => test_zci(qr/^$header([1-6] \+ ){3}[1-6] - [1-6] = \d{1,2}$/),
        "roll 2d6 and d20" => test_zci(qr/^$header\d (\+|-) \d = \d+<br\/>\d+<br\/>Total: \d+$/),
        "roll 2d6 and 3d12 + 4" => test_zci(qr/^$header\d (\+|-) \d = \d+<br\/>\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+<br\/>Total: \d+$/),
        "roll 2d6 and 3d12 - 4" => test_zci(qr/^$header\d (\+|-) \d = \d+<br\/>\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+<br\/>Total: \d+$/),
        "throw 3d12 - 4 and 2d6" => test_zci(qr/^$header\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d{1,2}<br\/>\d (\+|-) \d = \d+<br\/>Total: \d+$/),
        "throw 2d6 and 3d12 + 4" => test_zci(qr/^$header\d (\+|-) \d = \d+<br\/>\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+<br\/>Total: \d+$/),
        "roll 2d6 and 4d6-l" => test_zci(qr/^$header\d (\+|-) \d = \d+<br\/>([1-6] \+ ){3}[1-6] - [1-6] = \d{1,2}<br\/>Total: \d+$/),
        "roll 222d3 and 3d2" => undef,
        "roll the ball" => undef,
        "throw the ball" => undef,
        "roll " => undef,
        "roll the" => undef,
        "roll over" => undef,
);

done_testing;
