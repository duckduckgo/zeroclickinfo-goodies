#!/usr/bin/perl
use strict;

my $q_check_lc = 'binary Hello. My name is Inigo Montoya. You killed my father. Prepare to die.';

my $answer_results = '';
my $answer_type = '';
my $type = '';

if (!$type && $q_check_lc =~ m/^binary (.*)$/i) {
	
	sub bin {
		my @tex = shift;
		my $bin;
		for(my $x = 0; $x <= $#tex; $x++) {
			$bin .= unpack("B*", $tex[$x]);
		}
		return $bin;
	}
	
	my @tex = $1;
	$answer_results = bin(@tex);


	if ($answer_results) {
	    $answer_type = 'binary';
	    $type = 'E';
	}
}

print qq($answer_type\t$answer_results\n);
