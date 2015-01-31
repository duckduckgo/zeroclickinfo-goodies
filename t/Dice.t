#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'dice_roll';
zci is_cached => 0;

my $heading = 'Random Dice Roll';

ddg_goodie_test(
        [qw(
                DDG::Goodie::Dice
        )],

        # Check trigger kicks in.
        'throw dice' => test_zci(qr/^., .$/,
                html => qr/./,
                heading => $heading
        ),
        'roll dice' => test_zci(qr/^., .$/,
                html => qr/./,
                heading => $heading
        ),
        'throw die' => test_zci(qr/^.$/,
                html => qr/./,
                heading => $heading
        ),


        # Simple "dice" query
        "roll 5 dice" => test_zci(qr/., ., ., ., .$/,
                html => qr/./,
                heading => $heading
        ),

        # Simple shorthand query
        "roll 2d6" => test_zci(qr/^\d (\+|-) \d = \d+$/,
                html => qr/./,
                heading => $heading
        ),
        "throw 1d20" => test_zci(qr/^\d{1,2}$/,
                html => qr/./,
                heading => $heading
        ),
        "roll d20" => test_zci(qr/^\d{1,2}$/,
                html => qr/./,
                heading => $heading
        ),

        # Simple shorthand queries with +-
        "roll 3d12 + 4" => test_zci(qr/^\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d{1,2}$/,
                html => qr/./,
                heading => $heading
        ),
        "roll 3d8 - 8" => test_zci(qr/^\d (\+|-) \d (\+|-) \d (\+|-) \d = -?\d+$/,
                html => qr/./,
                heading => $heading
        ),
        "roll 4d6-l" => test_zci(qr/^([1-6] \+ ){3}[1-6] - [1-6] = \d{1,2}$/,
                html => qr/./,
                heading => $heading
        ),

        # Simple conjunctive "dice" query
        "throw 2 dice and 3 dice" => test_zci(qr/., .<br\/>., ., .<br\/>Total: \d+$/,
                html => qr/./,
                heading => $heading
        ),

        # Shorthand conjunctive query
        "roll 2w6 and d20" => test_zci(qr/^\d (\+|-) \d = \d+<br\/>\d+<br\/>Total: \d+$/,
                html => qr/./,
                heading => $heading
        ),

        # Shorthand conjunctive queries with +-
        "roll 2d6 and 3d12 + 4" => test_zci(qr/^\d (\+|-) \d = \d+<br\/>\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+<br\/>Total: \d+$/,
                html => qr/./,
                heading => $heading
        ),
        "roll 2d6 and 3d12 - 4" => test_zci(qr/^\d (\+|-) \d = \d+<br\/>\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = -?\d+<br\/>Total: \d+$/,
                html => qr/./,
                heading => $heading
        ),
        "throw 3d12 - 4 and 2d6" => test_zci(qr/^\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = -?\d{1,2}<br\/>\d (\+|-) \d = \d+<br\/>Total: \d+$/,
                html => qr/./,
                heading => $heading
        ),
        "throw 2d6 and 3d12 + 4" => test_zci(qr/^\d (\+|-) \d = \d+<br\/>\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+<br\/>Total: \d+$/,
                html => qr/./,
                heading => $heading
        ),
        "roll 2d6 and 4w6-l" => test_zci(qr/^\d (\+|-) \d = \d+<br\/>([1-6] \+ ){3}[1-6] - [1-6] = \d{1,2}<br\/>Total: \d+$/,
                html => qr/./,
                heading => $heading
        ),
        "roll 2 dice and 3d5 + 4" => test_zci(qr/^., .<br\/>\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+<br\/>Total: \d+$/,
                html => qr/./,
                heading => $heading
        ),

        # Don't trigger
        "roll 2d3 2d6 and 3d3" => undef,
        "roll 2d4 and 2d30 d30" => undef,
        "roll 222d3 and 3d2" => undef,
        "roll the ball" => undef,
        "throw the ball" => undef,
        "roll " => undef,
        "roll the" => undef,
        "roll over" => undef,
        "roll 0 dice" => undef,
        "roll 0d6" => undef,
        "roll 2d3 and 2d4-a" => undef,

        # Check the HTML. Just once for a longhand query.
        "throw die" => test_zci(qr/^.$/,
                html =>  qr/<span class="zci--dice-die">.<\/span><span class="zci--dice-sum"> = \d+<\/span><\/br>/,
                heading => $heading
        ),

        'roll 3d12' => test_zci(
            qr/\d{1,2} \+ \d{1,2} \+ \d{1,2} = \d+/,
            heading => $heading,
            html => qr/./,
        ),
        'roll 3d12 and 2d4' => test_zci(
            qr/\d{1,2} \+ \d{1,2} \+ \d{1,2} = \d+<br\/>[1-4]+ \+ [1-4]+ = \d<br\/>Total: \d+/,
            heading => $heading,
            html => qr/./,
        ),
        'roll 2 dice and 3d5' => test_zci(
            qr/<br\/>[1-5]+ \+ [1-5]+ \+ [1-5]+ = \d+<br\/>Total: \d+/,
            heading => $heading,
            html => qr/./,
        ),
);

done_testing;
