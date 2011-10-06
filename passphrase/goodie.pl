#!/usr/bin/perl
use strict;

my $q_check_lc = "passphrase $ARGV[$1] words";
my $answer_results = '';
my $answer_type = 'passphrase';

if ($q_check_lc =~ m/^passphrase ([1-9]+) word|words$/) {
    open(IN, 'list.txt');
    my %shows = ();
    while (my $line = <IN>) {
	chomp($line);
	my @res = split(/ /, $line);
	$shows{lc $res[0]} = $res[1];
	
    }
    close(IN);

    for (my $count = 0; $count < int($1); $count++) {
	my $ref_num = '';
	for (my $num = 0; $num < 5; $num++) {
	    # alea iacta est!!!
	    $ref_num .= int(rand(6)) + 1;
	}

	$answer_results .= "$shows{$ref_num} ";
    }
}

# Remove the trailing space
chop $answer_results;
print qq($answer_type\t$answer_results\n);
