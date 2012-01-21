if ($type ne 'E' && $q_check_lc =~ m/^(?:sig(?:figs|digs)|significant (?:figures|digits)|sf|sd) (-?\d+(?:\.(?:\d+)?)?)$/i) {
    my $string = $1;
    $string =~ s/-//;
    $string =~ s/^0+//;
    my @arr = split('\\.', $string);
    my $v = @arr;
    my $len = 0;
    # there's a decimal
    unless ($v eq 1) {
	# the string doesn't have integers on the left
	# this means we can strip the leading zeros on the right
	if ($string < 1) {
	    $arr[1] =~ s/^0+//;
	    $len = length $arr[1];
	}
	#there are integers on the left
	else {
	    $len = length($arr[0]) + length($arr[1]);
	}
    }
    # no decimal
    else {
	# lose the trailing zeros and count
	$string =~ s/\.?0*$//;
	$len = length $string;
    }
    $answer_results = qq(Significant figures: $len);
    if ($answer_results) {
	$answer_type = 'sigfigs';
	$type = 'E';
    }
}
