package DDG::Goodie::Cusip;
# ABSTRACT: Validate a CUSIP ID's check digit.

use DDG::Goodie;
use v5.16.3;
use POSIX;

# metadata
name "CUSIP check";
description "Validates the check digit for a unique stock identifier based on the Committee on Uniform Securities Identification Procedures";
primary_example_queries "cusip 037833100";
category "finance";
topics "economy_and_finance";
code_url "https://github.com/tommytommytommy/zeroclickinfo-goodies/lib/DDG/Goodie/Cusip.pm";
attribution github => ["https://github.com/tommytommytommy", 'tommytommytommy'];

triggers start =>
    "cusip";

zci answer_type => "cusip";
        
handle remainder => sub {

	# magic number to identify the length of the CUSIP ID   
    my $CUSIPLENGTH = 9;
    
    # strip beginning and end whitespace from remainder 
    s/^\s+|\s+$//g;
        
    # check that the remainder is the correct length
    return unless m/^(.{$CUSIPLENGTH})$/;
      
    # check that the remainder only contains alphanumeric chars and *, @, and #
    return if not m/^[a-zA-Z0-9\*\@\#]+$/;
    
	# capitalize all letters in the CUSIP
	tr/a-z/A-Z/;
	
	# aggregate checksum value 
	my $checksum = 0;

	# iteration index
	my $cusipIndex;

	# temporary variables for use within the for loop to store 
	# the current CUSIP character and its equivalent integer value
	my $currentCusipChar;
	my $currentCusipCharValue;
	
	# calculate the checksum for the CUSIP
    for ($cusipIndex = 0; $cusipIndex < $CUSIPLENGTH - 1; $cusipIndex++) {

		# extract the current CUSIP character
		$currentCusipChar = substr $_, $cusipIndex, 1;

		# map the current CUSIP character into its integer value
		# based on the pseudo algorithm provided by
		# https://en.wikipedia.org/wiki/CUSIP#Check_digit_pseudocode
		$currentCusipCharValue = 0;
		for ($currentCusipChar) {
        	$currentCusipCharValue = ord($currentCusipChar) - ord('0') when /[0-9]/;
        	$currentCusipCharValue = ord($currentCusipChar) - ord('A') + 10 when /[A-Z]/;
        	$currentCusipCharValue = 36 when $currentCusipChar eq '*';
        	$currentCusipCharValue = 37 when $currentCusipChar eq '@';
			$currentCusipCharValue = 38 when $currentCusipChar eq '#';
        	default { $currentCusipCharValue = 0; }
      	}
      	
		# double the CUSIP value for every other character starting with the second
		if (($cusipIndex + 1) % 2 == 0) {
			$currentCusipCharValue *= 2;
		} 
	
		# the pseudocode in Wikipedia does not explicitly state that floor()
		# is required, but empirical testing with 037833100 for AAPL and 
		# 38259P706 and 38259P508 for GOOG shows that floor() is necessary
		$checksum += floor($currentCusipCharValue / 10) + $currentCusipCharValue % 10;
    }

	# convert the checksum into a single check digit
	my $checkDigit = (10 - ($checksum % 10)) % 10;

	# return the validity of the CUSIP
    return "$_ has a valid CUSIP check digit." if $checkDigit eq substr($_, -1);
	return "$_ does NOT have a valid CUSIP check digit.";    	
};

1;
