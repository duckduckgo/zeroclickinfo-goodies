package DDG::Goodie::Average;

use DDG::Goodie;

triggers startend => "avg", "average", "mean", "median";
triggers start => "root";

zci is_cached => 1;
zci answer_type => "average";

primary_example_queries 'average 12, 45, 78, 1234';
secondary_example_queries 'avg 1,2,3', 'root mean square 1,2,3';
description 'take the average of a list of numbers';
name 'Average';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Average.pm';
category 'calculations';
topics 'math';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

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
