#!/usr/bin/perl

use strict;
use warnings;

my $q_check_lc = 'private network';
my $answer_results = '';
my $answer_type = '';
my $type = '';

my %private_network = map { $_ => undef } (
    'private network',
    'private networks',
    'private network ip',
    'private network ips',
    'private network address',
    'private network addresses',
    'private ip',
    'private ips',
    'private ip addresses',
    'private ip address',
    );


if ($type ne 'E' && exists $private_network{$q_check_lc}) {

    open(IN,"<privatenetwork.html");
    while (my $line = <IN>) {
	$answer_results .= $line;
    }
    close(IN);

    if ($answer_results) {
	$answer_type = 'network';
	$type = 'E';
    }
}


print qq($answer_type\t$answer_results\n);
