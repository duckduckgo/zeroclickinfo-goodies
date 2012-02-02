
# Outputs the mean and median of the queried numbers.

if (!$type && $q_check =~ m/^(?:avg|average) {?([\-?0-9.,?;? ?]*)}?$/i) {
    # get an array of the entered numbers
    my @nums = split(m/(?:, ?| |; ?)/, $1);
    my $item;
    foreach $item (@nums) {
	$item =~ s/[;,]//g;
    }
    # initialize the sum
    my $sum = 0;
    # calculate the sum
    $sum += $_ for @nums;
    # get the length of the array
    my $len = @nums;
    # calculate the mean
    my $mean = $sum/$len;
    # sort the list numerically, least to greatest
    @nums = sort { $a <=> $b } @nums;
    my $med = 0;
    if ($len % 2 eq 0) {
	# get the two middle numbers, since the 
	# length is even, and calculate their mean
	$med = ($nums[$len/2] + $nums[$len/2-1])/2;
    }
    else {
	# get the middle number
	$med = $nums[int($len/2)]
    }
    my $rms = 0;
    $rms += ($_ ** 2) for @nums;
    $rms /= $len;
    $rms = sqrt $rms;
    # set the results
    $answer_results = qq(Mean: $mean\nMedian: $med\nRoot Mean Square: $rms);
    if ($answer_results) {
	$answer_type = 'average';
	$type = 'E';
    }
}
