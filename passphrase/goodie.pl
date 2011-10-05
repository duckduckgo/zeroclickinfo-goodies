#!/usr/bin/perl
use strict;
use warnings;

my $q_check_lc = 'passphrase 4 words';
my $answer_results = '';
my $answer_type = 'passphrase';

if ( $q_check_lc =~ m/^passphrase ([1-9]) word|words$/ ) {

    sub word_for_num {
	# use grep because the file is pretty large
	my $match = shift;
	my $result = `grep $match list.txt`;
	# don't include the reference number in the passphrase
	$result = substr($result, 6, length($result));
	#remove the newline from the end of the grep result
	chomp($result);
	# add so there's a space between passphrase words
	$result .= " ";
	return sub { "$result" }
    }

    for (my $count = 0; $count < int($1); $count++) {
	my $ref_num = '';
	for (my $num = 0; $num < 5; $num++) {
	    # alea iacta est!!!
	    $ref_num .= int(rand(6)) + 1;
	}
	$answer_results .= word_for_num($ref_num)->();
    }

    # remove the trailing space from the results. 
    # There is a space added to the last word by $result .= " " in word_for_num
    $answer_results =~ s/\s+$//;
    $answer_type = 'passphrase';
}

print qq($answer_type\t$answer_results\n);
