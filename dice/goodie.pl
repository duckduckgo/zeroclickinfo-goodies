#!/usr/bin/perl
# Throw 6 sided die

use strict;
use warnings;

my $q_check_lc = 'throw 5 dice';
my $answer_results = '';
my $answer_type = 'dice_side';
my $choices = 6;  # To be replace with input string in the future

if ( $q_check_lc =~ m/^throw(?:\sdie|(\d{0,2}\s)*dice)$/ ) {
    my $rolls = 1;  # If "die" is entered

    if (defined($1)) {    # Not defined if number of "dice" not specified
        if ($1 eq " ") {
            $rolls = 2;

        }
        else {
            $rolls = $1;
        }
    }

    for (1 .. $rolls) {
        my $roll = int(rand($choices)) + 1;
        $answer_results .= " $roll";
    }

    print qq($answer_type\t$answer_results\n);
}
