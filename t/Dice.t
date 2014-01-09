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
        'throw dice' => test_zci(qr/^., .$/, 
                html => qr//, 
                heading => 'Random Dice Roll'
        ),
        "roll 5 dice" => test_zci(qr/., ., ., ., .$/, 
                html => qr//, 
                heading => 'Random Dice Roll'
        ),
        "throw die" => test_zci(qr/^.$/, 
                html => qr//, 
                heading => 'Random Dice Roll'
        ),
        "roll 2d6" => test_zci(qr/^\d (\+|-) \d = \d+$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "roll 3d12 + 4" => test_zci(qr/^\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d{1,2}$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "throw 1d20" => test_zci(qr/^\d{1,2}$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "roll 3d8 - 8" => test_zci(qr/^\d (\+|-) \d (\+|-) \d (\+|-) \d = -?\d+$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "roll d20" => test_zci(qr/^\d{1,2}$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "roll 4d6-l" => test_zci(qr/^([1-6] \+ ){3}[1-6] - [1-6] = \d{1,2}$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "roll 2d6 and d20" => test_zci(qr/^\d (\+|-) \d = \d+<br\/>\d+<br\/>Total: \d+$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "roll 2d6 and 3d12 + 4" => test_zci(qr/^\d (\+|-) \d = \d+<br\/>\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+<br\/>Total: \d+$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "roll 2d6 and 3d12 - 4" => test_zci(qr/^\d (\+|-) \d = \d+<br\/>\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+<br\/>Total: \d+$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "throw 3d12 - 4 and 2d6" => test_zci(qr/^\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d{1,2}<br\/>\d (\+|-) \d = \d+<br\/>Total: \d+$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "throw 2d6 and 3d12 + 4" => test_zci(qr/^\d (\+|-) \d = \d+<br\/>\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+<br\/>Total: \d+$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "roll 2d6 and 4d6-l" => test_zci(qr/^\d (\+|-) \d = \d+<br\/>([1-6] \+ ){3}[1-6] - [1-6] = \d{1,2}<br\/>Total: \d+$/, 
                html => qr//,
                heading => 'Random Dice Roll'
        ),
        "roll 2d3 2d6 and 3d3" => undef,
        "roll 2d4 and 2d30 d30" => undef,
        "roll 222d3 and 3d2" => undef,
        "roll the ball" => undef,
        "throw the ball" => undef,
        "roll " => undef,
        "roll the" => undef,
        "roll over" => undef,
);

done_testing;
