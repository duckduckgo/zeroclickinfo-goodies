#!/usr/bin/perl
# Throw 6 sided die

use strict;
use warnings;

my $choices = 6;
my $choice = int(rand($choices)) + 1;
print "$choice\n";
