#!/usr/bin/perl
#
# Choose between the values stored in @choices

use strict;
use warnings;

my @choices = ('A', 'B', 'C');

my $choice = int(rand($choices));
print "$choices[$choice]\n";
