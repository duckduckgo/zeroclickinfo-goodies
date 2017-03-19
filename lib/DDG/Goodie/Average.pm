package DDG::Goodie::Average;
# ABSTRACT: take statistics for a list of numbers

use strict;
use DDG::Goodie;

triggers startend => "avg", "average", "mean", "median", "root mean square", "rms";

zci is_cached => 1;
zci answer_type => "average";

handle remainder => sub {

    my $query = $req->query_lc;
    
    my $type;
    if ($query =~ m/root mean square|rms/) {
        $type = "Root Mean Square";
    } elsif ($query =~ m/avg|average|mean/) {
        $type = "Mean";
    } else {
        $type = "Median";
    }

    #Remove leading/trailing text from list of numbers
    s/^[a-zA-Z\s]+//;
    s/\s+[a-zA-Z]+$//;

    #Ensure numbers are space-delimited
    s/[;,\s{}\[\]\(\)]+/ /g;

    #Return unless only left with space-delimited list of numbers
    return unless /^\s*(?:\d+(?:\.\d+)?\s?)*$/;

    #Get numbers into an array
    my @nums = split ' ', $_;

    #Must have at least two numbers
    return unless @nums > 1;

    # initialize the sum
    my $sum;

    # calculate the sum
    $sum += $_ for @nums;

    # get the length of the array
    my $len = @nums;

    my $result;
    
    if ($type eq "Mean") {
        # calculate the mean
        $result = $sum/$len;
    } elsif ($type eq "Median")  {
        # sort the list numerically, least to greatest
        @nums = sort { $a <=> $b } @nums;
        if ($len % 2 eq 0) {
            # get the two middle numbers, since the
            # length is even, and calculate their mean
            $result = ($nums[$len/2] + $nums[$len/2-1])/2;
        } else {
            # get the middle number
            $result = $nums[int($len/2)]
        }
    } else {
        $result += ($_ ** 2) for @nums;
        $result /= $len;
        $result = sqrt $result;  
    }
    
    return "$type: $result",
        structured_answer => {
            data => {
                title => $result,
                subtitle => "$type of: $_"
            },
            templates => {
                group => 'text'
            }
    };
    
};

1;
