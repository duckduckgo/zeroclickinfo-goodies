package DDG::Goodie::Average;

use DDG::Goodie;

triggers startend => "avg", "average", "mean", "median";
triggers start => "root";

zci is_cached => 1;
zci answer_type => "average";

handle query => sub {
    return if $_ =~ /^root/i && $_ !~ /^root mean square/i;

    s/^[a-zA-Z\s]+//; s/\s+[a-zA-Z]+$//; s/[;,\s]+/ /g;
    return unless /^\s*(?:\d+(?:\.\d+)?\s?)*$/;

    my @nums = split ' ', $_;
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
    return "Mean: $mean; Median: $med; Root Mean Square: $rms", html => "Mean: <b>$mean</b>; Median: <b>$med</b>; Root Mean Square: <b>$rms</b>";
};

1;
