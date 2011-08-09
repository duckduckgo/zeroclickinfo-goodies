#!/usr/bin/perl
#
# Choose between the values stored in @choices

use strict;
use warnings;

my $q_check_lc = 'this or that or none';
my $answer_results = '';
my $answer_type = '';

if ( $q_check_lc =~ m/^\s*[^\s]+(\s+or\s+[^\s]+)+\s*$/ ) {
    my @choices = split(/\s+or\s+/, $q_check_lc);
    my $choice = int(rand(@choices));

    $answer_results = $choices[$choice];
    $answer_type = 'choice';
}

print qq($answer_type\t$answer_results\n);

