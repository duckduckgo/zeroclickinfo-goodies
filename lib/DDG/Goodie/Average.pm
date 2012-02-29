package DDG::Goodie::Average;

use DDG::Goodie;

triggers startend => "avg", "average", "mean";

zci is_cached => 1;

handle query_parts => sub {
    my @nums;
    for (@_) {
        if ($_ =~ /-?\d+/) { 
            $_ =~ s/[;,]//g;
            push @nums, $_;
        }
    }
    return unless @nums;
    # initialize the sum
    my $sum;

    # calculate the sum
    $sum += $_ for @nums;

    # get the length of the array
    my $len = @nums;

    # calculate the mean
    my $mean = $sum/$len;

    # sort the list numerically, least to greatest
    @nums = sort { $a <=> $b } @nums;
    my $med;
    if ($len % 2 eq 0) {
        # get the two middle numbers, since the 
        # length is even, and calculate their mean
        $med = ($nums[$len/2] + $nums[$len/2-1])/2;
    } else {
        # get the middle number
        $med = $nums[int($len/2)]
    }

    my $rms;
    $rms += ($_ ** 2) for @nums;
    $rms /= $len;
    $rms = sqrt $rms;
    return "Mean: $mean\nMedian: $med\nRoot Mean Square: $rms";

};

1;
