#!/usr/bin/perl

use strict;
use warnings;

use Data::GUID;

if (my $guid = Data::GUID->new) {
    print "{$guid}\n";
}
