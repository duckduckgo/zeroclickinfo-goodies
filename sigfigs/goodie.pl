if ($type ne 'E' && $q_check_lc =~ m/^(?:sig(?:figs|digs)|significant (?:figures|digits)|sf|sd) (-?\d+(?:\.(?:\d+)?)?)$/i) {
    my $string = $1;
    $string =~ s/-//;
    # if there's no decimal place
    if (index($string, '.') eq -1) {
	# remove trailing and leading zeros
	$string =~ s/\.?0*$//;
	$string =~ s/^0+//;
	# get the length, which is the sigfig value.
	my $len = length $string;
	$answer_results = qq($len);
    }
    # there is a decimal
    else {
	$string =~ s/^0+//;
	my @zer = split("\\.", $string);
	my $len = 0;
	# no integers to the left
	if (length($zer[0]) eq 0) {
	    $zer[1] =~ s/^0+//;
	    $len = length $zer[1];
	}
	# there are integers to the left
	else {
	    $len = length($zer[0]) + length($zer[1]);
	}
	$answer_results = qq(Significant figures: $len);
    }
    if ($answer_results) {
	$answer_type = 'sigfigs';
	$type = 'E';
    }
}
