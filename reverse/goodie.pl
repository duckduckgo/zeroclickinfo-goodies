
# Outputs the query in reverse order.

if (!$type && $q_check =~ m/^reverse (.+)$/i) {
		
	$answer_results = reverse $1;
	
	if ($answer_results) {
		$answer_type = 'reverse';
		$type = 'E';
	}
}
