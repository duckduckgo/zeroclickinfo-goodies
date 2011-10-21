
# Outputs the query in binary format.

if (!$type && $q_check =~ m/^binary (.*)$/i) {
	
    sub bin {
	my @tex = shift;
	my $bin;
	for(my $x = 0; $x <= $#tex; $x++) {
	    $bin .= unpack("B*", $tex[$x]);
	}
	return $bin;
    }
    
    my @tex = $1;
    $answer_results = bin(@tex);
    
    
    if ($answer_results) {
	$answer_type = 'binary';
	$type = 'E';
    }
}
