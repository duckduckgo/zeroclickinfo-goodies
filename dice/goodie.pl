#!/usr/bin/perl
# Throw 6 sided die

use strict;
use warnings;

my $q_check_lc = 'roll 5 dice';

my $answer_results = '';
my $answer_type = '';
my $type = '';
my $is_memcached = 1;

if (!$type && $q_check_lc =~ m/^(?:roll|throw)(?:\sdie|(\d{0,2}\s)*dice)$/ ) {
    my $rolls = 1;  # If "die" is entered
    my $choices = 6;  # To be replace with input string in the future

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

    $answer_type = 'dice';
    $is_memcached = 0;
}

print qq($answer_type\t$answer_results\n);
