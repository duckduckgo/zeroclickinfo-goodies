#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'dice_roll';
zci is_cached => 0;

my $structured_answer = {
    id => 'dice',
	name => 'Random Dice',
    result => qr/^\d+$/,
    templates => {
        group => 'text',
        item => 0,
        options => {
            content => 'DDH.dice.content'
        }
    },
    data => '-ANY-'
    #{
    #    rolls => 'An array containing each different set of rolls',
    #    total => qr/^\d*$/,
    #    show_total => 'empty or 1, depending on how many requests were made'
    #}
};

sub valid_roll_of_faces {
    my $faces = $_[0];
    return '('.join('|', 1..$faces).')';
}

sub rolls_of {
    my @values = (@_);
    my @rolls = map { [$_->[0], valid_roll_of_faces($_->[1]), $_->[2]] } @values;
    my $regex = join('\\\\n', map { join(' \+ ', ($_->[1]) x $_->[0]).( $_->[2] ? ' \('.$_->[2].'\)': '').($_->[0] > 1 ? ' = \d+' : '') } @rolls);
    return qr/^$regex/;
}

ddg_goodie_test(
       ['DDG::Goodie::Dice'],

        # Check trigger kicks in.
        'throw dice' => test_zci(
            rolls_of([2, 6]),
            structured_answer => $structured_answer
        ),
        'throw dices' => test_zci(
            rolls_of([2, 6]),
            structured_answer => $structured_answer
        ),
        'roll dice' => test_zci(
            rolls_of([2, 6]),
            structured_answer => $structured_answer
        ),
        'throw die' => test_zci(
            rolls_of([1, 6]),
            structured_answer => $structured_answer
        ),

        # Simple "dice" query, specifying number
        'roll 5 dice' => test_zci(
            rolls_of([5, 6]),
            structured_answer => $structured_answer
        ),
        
        # Simple shorthand query
        "roll 2d6" => test_zci(
            rolls_of([2, 6]),
            structured_answer => $structured_answer
        ),
        "throw 1d20" => test_zci(
            rolls_of([1, 20]),
            structured_answer => $structured_answer
        ),
        "roll d20" => test_zci(
            rolls_of([1, 20]),
            structured_answer => $structured_answer
        ),

        # Simple shorthand queries with +-
        "roll 3d12 + 4" => test_zci(
            rolls_of([3, 12, '\+4']),
            structured_answer => $structured_answer
        ),
        "roll 3d8 - 8" => test_zci(
            rolls_of([3, 8, '\-8']),
            structured_answer => $structured_answer
        ),
        "roll 4d6-l" => test_zci(
            rolls_of([4, 6, '\-'.valid_roll_of_faces(6)]),
            structured_answer => $structured_answer
        ),
        "roll 4d6-h" => test_zci(
            rolls_of([4, 6, '\-'.valid_roll_of_faces(6)]),
            structured_answer => $structured_answer
        ),

        # Simple conjunctive "dice" query
        "throw 2 dice and 3 dice" => test_zci(
            rolls_of([2, 6], [3, 6]),
            structured_answer => $structured_answer
        ),

        # Shorthand conjunctive query
        "roll 2w6 and d20" => test_zci(
            rolls_of([2, 6], [1, 20]),
            structured_answer => $structured_answer
        ),

        # Shorthand conjunctive queries with +-
        "roll 2d6 and 3d12 + 4" => test_zci(
            rolls_of([2, 6], [3, 12, '\+4']),
            structured_answer => $structured_answer
        ),
        "roll 2d6 and 3d12 - 4" => test_zci(
            rolls_of([2, 6], [3, 12, '\-4']),
            structured_answer => $structured_answer
        ),
        "throw 3d12 - 4 and 2d6" => test_zci(
            rolls_of([3, 12, '\-4'], [2, 6]),
            structured_answer => $structured_answer
        ),
        "throw 2d6 and 3d12 + 4" => test_zci(
            rolls_of([2, 6], [3, 12, '\+4']),
            structured_answer => $structured_answer
        ),
        "roll 2d6 and 4w6-l" => test_zci(
            rolls_of([2, 6], [4, 6, '\-'.valid_roll_of_faces(6)]),
            structured_answer => $structured_answer
        ),
        "roll 2 dice and 3d5 + 4" => test_zci(
            rolls_of([2, 6], [3, 5, '\+4']),
            structured_answer => $structured_answer
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
        "roll 2d3 and 2d4-a" => undef
);

done_testing;
