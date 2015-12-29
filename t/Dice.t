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
    'throw dice' => test_zci(
        qr/^., .$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    'roll dice' => test_zci(
        qr/^., .$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    'throw die' => test_zci(
        qr/^.$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),


    # Simple "dice" query
    "roll 5 dice" => test_zci(
        qr/., ., ., ., .$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),

    # Simple shorthand query
    "roll 2d6" => test_zci(
        qr/^\d (\+|-) \d$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    "throw 1d20" => test_zci(
        qr/^\d{1,2}$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    "roll d20" => test_zci(
        qr/^\d{1,2}$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),

    # Simple shorthand queries with +-
    "roll 3d12 + 4" => test_zci(
        qr/^\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2}$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    "roll 3d8 - 8" => test_zci(
        qr/^\d (\+|-) \d (\+|-) \d (\+|-) \d$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    "roll 4d6-l" => test_zci(
        qr/^([1-6] \+ ){3}[1-6] - [1-6]$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),

    # Simple conjunctive "dice" query
    "throw 2 dice and 3 dice" => test_zci(
        qr/., .., ., .Total: \d+$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),

    # Shorthand conjunctive query
    "roll 2w6 and d20" => test_zci(
        qr/^\d (\+|-) \d = \d+\d+Total: \d+$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),

    # Shorthand conjunctive queries with +-
    "roll 2d6 and 3d12 + 4" => test_zci(
        qr/^\d (\+|-) \d = \d+\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+Total: \d+$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    "roll 2d6 and 3d12 - 4" => test_zci(
        qr/^\d (\+|-) \d = \d+\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = -?\d+Total: \d+$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    "throw 3d12 - 4 and 2d6" => test_zci(
        qr/^\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = -?\d{1,2}\d (\+|-) \d = \d+Total: \d+$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    "throw 2d6 and 3d12 + 4" => test_zci(
        qr/^\d (\+|-) \d = \d+\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+Total: \d+$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    "roll 2d6 and 4w6-l" => test_zci(
        qr/^\d (\+|-) \d = \d+([1-6] \+ ){3}[1-6] - [1-6] = \d{1,2}Total: \d+$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    "roll 2 dice and 3d5 + 4" => test_zci(
        qr/^., .\d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} (\+|-) \d{1,2} = \d+Total: \d+$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
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

    "throw die" => test_zci(
        qr/^.$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),

    'roll 3d12' => test_zci(
        qr/\d{1,2} \+ \d{1,2} \+ \d{1,2}/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    'roll 3d12 and 2d4' => test_zci(
        qr/\d{1,2} \+ \d{1,2} \+ \d{1,2} = \d+[1-4]+ \+ [1-4]+ = \dTotal: \d+/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
    'roll 2 dice and 3d5' => test_zci(
        qr/[1-5]+ \+ [1-5]+ \+ [1-5]+ = \d+Total: \d+/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
       }
    ),
);

done_testing;
