#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use Getopt::Std;

use Data::Dumper;

my %opts;

getopts('f:t',\%opts);

if ($opts{f} and $opts{t}) {
	print "Please just use -f or -t not both at once\n";
	exit 1;
}

my $goodie = shift @ARGV;

if (!$goodie) {
	print "Please give a name of the goodie you want to test!\n";
	exit 1;
}

my @queries;

if (@ARGV) {
	push @queries, join(' ',@ARGV);
} elsif ($opts{f}) {
	open FILE, $opts{f} or die "Couldn't open file ".$opts{f}.": $!"; 
	for (<FILE>) {
		chomp;
		push @queries, $_;
	}
	close FILE;
} elsif ($opts{t}) {
	my $test_query_file = $Bin."/".$goodie."/queries.txt";
	open FILE, $test_query_file or die "Couldn't open file ".$test_query_file.": $!"; 
	for (<FILE>) {
		chomp;
		push @queries, $_;
	}
	close FILE;
} else {
	print "Please give a query to test ".$goodie." goodie or a file with queries via -f or make execute the goodie testset with -t!\n";
	exit 1;
}

my $filename = $Bin."/".$goodie."/goodie.pl";

if (!-r $filename) {
	print "Can't find ".$filename."!";
	exit 1;
}

open FILE, $filename or die "Couldn't open file: $!"; 
my $code = join("", <FILE>); 
close FILE;

for (@queries) {

    my $q = $_;
    next if !$q;

    my $q_check = $q;
    my $q_check_lc = lc $q_check;
    my $q_internal = $q_check_lc;
    my $q = $q_check;
    my $type = '';
    my $is_memcached = 1;

	my $answer_results;
	my $answer_type;

	eval $code;
	
	print "\n";

	if ($answer_results and !$answer_type) {
		print 'The goodie doesnt set $answer_type, but has $answer_results on "'.$_.'". You must give back $answer_results!'."\n";
	} 

	if ($answer_results and $answer_type) {
		print 'The goodie '.$goodie.' gives back the following on the query "'.$q_check.'":'."\n";
		print 'Answer Type: '.$answer_type."\n";
		print 'Answer Type: '.$answer_results."\n";
	} else {
		print 'The goodie '.$goodie.' gave no result on "'.$q_check.'"!'."\n";
	}
}

print "\n";
