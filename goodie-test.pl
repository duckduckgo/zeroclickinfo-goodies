#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);

my $goodie = shift @ARGV;

if (!$goodie) {
	print "Please give a name of the goodie you want to test!\n";
	exit 1;
}

if (!@ARGV) {
	print "Please give a query to test ".$goodie." goodie!\n";
	exit 1;
}

my $filename = $Bin."/".$goodie."/".$goodie.".pl";

if (!-r $filename) {
	print "Can't find ".$filename."!";
	exit 1;
}

open FILE, $filename or die "Couldn't open file: $!"; 
my $code = join("", <FILE>); 
close FILE;

my $q_check = join(' ',@ARGV);
my $q_internal = '';

my $answer_results;
my $answer_type;

eval $code;

if ($answer_results and !$answer_type) {
	print 'The goodie doesnt set $answer_type, but has $answer_results. You must give back $answer_results';
} 

if ($answer_results and $answer_type) {
	print 'The goodie '.$goodie.' gives back the following on the query "'.$q_check.'":'."\n";
	print 'Answer Type: '.$answer_type."\n";
	print 'Answer Type: '.$answer_results."\n";
} else {
	print 'The goodie '.$goodie.' gave no result on "'.$q_check.'"!'."\n";
}
