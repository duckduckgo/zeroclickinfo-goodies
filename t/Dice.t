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
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
            }
       }
    ),
    'throw dices' => test_zci(
        qr/^., .$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
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
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
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
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
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
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
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
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
            }
       }
    ),

    # Query with numbers as words
    "roll five dice" => test_zci(
        qr/., ., ., ., .$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
            }
       }
    ),
    "roll twenty five dice" => test_zci(
        qr/., ., ., ., .$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
            }
       }
    ),
    "roll fifty-four dice" => test_zci(
        qr/., ., ., ., .$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
            }
       }
    ),
    "roll seven dices" => test_zci(
        qr/., ., ., ., .$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
            }
       }
    ),
    # Invalid numeric words
    "roll foo dice" => undef,

    "throw 1d20" => test_zci(
        qr/^\d{1,2}$/,
        structured_answer => {
            id => 'dice',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
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
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
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
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
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
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
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
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
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
                group => 'list',
                options => {
                    list_content => 'DDH.dice.content'
                }
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
                group => 'list',
                options => {
                    list_content => 'DDH.dice.content'
                }
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
                group => 'list',
                options => {
                    list_content => 'DDH.dice.content'
                }
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
                group => 'list',
                options => {
                    list_content => 'DDH.dice.content'
                }
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
                group => 'list',
                options => {
                    list_content => 'DDH.dice.content'
                }
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
                group => 'list',
                options => {
                    list_content => 'DDH.dice.content'
                }
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
                group => 'list',
                options => {
                    list_content => 'DDH.dice.content'
                }
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
                group => 'list',
                options => {
                    list_content => 'DDH.dice.content'
                }
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
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
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
                options => {
                    subtitle_content => 'DDH.dice.subtitle_content'
                }
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
                group => 'list',
                options => {
                    list_content => 'DDH.dice.content'
                }
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
                group => 'list',
                options => {
                    list_content => 'DDH.dice.content'
                }
            }
       }
    ),
);

done_testing;
