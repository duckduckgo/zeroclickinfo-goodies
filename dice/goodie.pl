

if (!$type && $q_check_lc =~ m/^(?:roll|throw)/) {
    
    if (!$type && $q_check_lc =~ m/^(?:roll|throw)(?:\sdie|(\d{0,2}\s)*dice)$/ ) {
	my $rolls = 1;  # If "die" is entered
	my $choices = 6;  # To be replace with input string in the future
	
	if (defined($1)) {    # Not defined if number of "dice" not specified
	    if ($1 eq " ") {
		$rolls = 2;
		
	    }
	    else {
		$rolls = $1;
	    }
	}
	
	for (1 .. $rolls) {
	    my $roll = int(rand($choices)) + 1;
	    $answer_results .= " $roll";
	}
	
	$answer_type = 'dice';
	$is_memcached = 0;
	
    } elsif (!$type && $q_check_lc =~ m/^(?:roll|throw)\s(\d{0,2})d(\d+)\s?([+-])?\s?(\d+|[lh])?$/) {
	my $number_of_dice = $1;
	my $number_of_faces = $2;
	my @rolls;
	for (1 .. $number_of_dice) {
	    push(@rolls, int(rand($number_of_faces)) + 1);
	}
	if (defined($3) && defined($4)) {
	    # handle special case of " - L" or " - H"
	    if ($3 eq '-' && ($4 eq 'l' || $4 eq 'h')) {
		@rolls = sort(@rolls);
		if ($4 eq 'l') {
		    shift(@rolls);
		} else {
		    pop(@rolls);
		}
	    } else {
		push(@rolls, int("$3$4"));
	    }
	}
	$answer_results = 0;
	for (@rolls) {
	    $answer_results += $_;
	}
	$answer_type = 'dice';
	$is_memcached = 0;
    }
}
