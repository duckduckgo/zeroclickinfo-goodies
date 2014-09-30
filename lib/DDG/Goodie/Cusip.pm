package DDG::Goodie::Cusip;
# ABSTRACT: Validate a CUSIP ID's check digit.

use DDG::Goodie;

# metadata
name "CUSIP check";
description "Validates the check digit for a unique stock identifier based on the Committee on Uniform Securities Identification Procedures";
primary_example_queries "cusip 037833100";
category "finance";
topics "economy_and_finance";
code_url "https://github.com/tommytommytommy/zeroclickinfo-goodies/lib/DDG/Goodie/Cusip.pm";
attribution github => ["https://github.com/tommytommytommy", 'tommytommytommy'];

triggers startend =>
    "cusip";

zci answer_type => "cusip";
        
handle remainder => sub {

    # magic number to identify the length of the CUSIP ID    
    my $CUSIPLENGTH = 9;
    
    # strip beginning and end whitespace from remainder 
    s/^\s+|\s+$//g;
       
    # capitalize all letters in the CUSIP
    $_ = uc;

    # check that the remainder is the correct length and 
    # only contains alphanumeric chars and *, @, and #
    return if not m/^[A-Z0-9\*\@\#]{$CUSIPLENGTH}$/;
       
    # split the CUSIP ID (without check digit) into an array of characters
    my @cusipIdChars = split(//, $_);
    my $inputCheckDigit = pop @cusipIdChars;

    # aggregate checksum value 
    my $checksum = 0;

    # index variable to track current CUSIP char   
    my $cusipIndex = 0;

    # calculate the checksum for the CUSIP ID
    foreach (@cusipIdChars) {       
   
        # this variable stores the integer equivalent of the CUSIP character
        my $currentCusipCharValue = 0;

        # map the current CUSIP character into its integer value
        # based on the pseudo algorithm provided by
        # https://en.wikipedia.org/wiki/CUSIP#Check_digit_pseudocode
        if (m/[0-9]/) {
            $currentCusipCharValue = ord($_) - ord('0');
        } elsif (m/[A-Z]/) {
            $currentCusipCharValue = ord($_) - ord('A') + 10;
        } elsif ($_ eq '*') {
            $currentCusipCharValue = 36;
        } elsif ($_ eq '@') {
            $currentCusipCharValue = 37;
        } elsif ($_ eq '#') {
            $currentCusipCharValue = 38;
        } else {
            $currentCusipCharValue = 0;
        }
                         
        # double the CUSIP value for every other character starting with the second
        if (($cusipIndex + 1) % 2 == 0) {
            $currentCusipCharValue *= 2;
        } 
            
        # the pseudocode in Wikipedia does not explicitly state that truncating 
        # the division result is necessary, but empirical testing 
        # with 037833100 for AAPL and 38259P706 and 38259P508 for GOOG show
        # that the truncation is necessary
        $checksum += int($currentCusipCharValue / 10) + $currentCusipCharValue % 10;   
        
        # increment the character position counter
        $cusipIndex++; 
    }

    # convert the checksum into a single check digit
    my $calculatedCheckDigit = chr((10 - ($checksum % 10)) % 10 + ord('0'));

    # store answer-specific strings
    my ($article, $result);
    
    # return the validity of the CUSIP
    if ($calculatedCheckDigit eq $inputCheckDigit) {
        $article = "a";
        $result = "valid";
    } else {
        $article = "an";
        $result = "invalid";
    }

    # create and output results
    my $output = html_enc($_)." has $article $result CUSIP check digit.";
    my $htmlOutput = "<div class='zci--cusip text--primary'>".html_enc($_)."<span class='text--secondary'> has $article </span>$result<span class='text--secondary'> CUSIP check digit.</span></div>";
    return $output, html => $htmlOutput;
};

1;
