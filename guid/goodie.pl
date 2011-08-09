#!/usr/bin/perl

use strict;
use warnings;

my $q_check_lc = 'guid';
my $answer_results = '';
my $answer_type = 'guid';

my %guid = (
    'guid' => 0,
    'uuid' => 1,
    'globally unique identifier' => 0,
    'universally unique identifier' => 1,
    'rfc 4122' => 0,
    );

if (exists $guid{$q_check_lc}) {

    # For debugging.
#    warn $q_check_lc;

    use Data::GUID;

    if (my $guid = Data::GUID->new) {
	if ($guid{$q_check_lc}) {
	    $guid = lc $guid;
	} else {
	    $guid = qq({$guid});
	}
	
	$answer_results = $guid;
	$answer_type = 'guid';
    }
}


print qq($answer_type\t$answer_results\n);
