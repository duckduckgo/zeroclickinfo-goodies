use Roman;

if (!$type && $q_check =~ /^(?:(?:roman|arabic))?\s*([mdclxvi]+)$/i) {
    
	$answer_results = arabic $1;
	
	if ($answer_results) {
		$answer_type = 'roman';
		$type = 'E';
	}
} elsif (!$type && $q_check =~ m/^roman ([0-9]+)$/i) {
   	
    $answer_results = uc(roman($1));
	
	if ($answer_results) {
		$answer_type = 'roman';
		$type = 'E';
	}

}

