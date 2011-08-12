#!/usr/bin/perl
#
# Choose between the values matched between 'or' in input
# Must be alphabetic values

use strict;
use warnings;

my $q_check_lc = 'this or 2 or none';
my $answer_results = '';
my $answer_type = '';

if ( $q_check_lc =~ m/^\s*[a-z]+(\s+or\s+[a-z]+)+\s*$/ ) {
    my @choices = split(/\s+or\s+/, $q_check_lc);
    my $choice = int(rand(@choices));

    $answer_results = $choices[$choice];
    $answer_type = 'choice';
}

print qq($answer_type\t$answer_results\n);

