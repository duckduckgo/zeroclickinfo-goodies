
# Outputs the numerical length of the query.

if (!$type && $q_check =~ m/^length (.+)$/i) {
      {   
        use Encode;
        $answer_results = length decode_utf8($1);
      }
	if ($answer_results) {
                $answer_results = qq(Length: $answer_results);
		$answer_type = 'length';
		$type = 'E';
	}
}

