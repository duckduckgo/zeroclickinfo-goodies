if ($type ne 'E' && $q_check_lc =~ m/scruffy(?:\-| |)looking nerf(?:\-| |)herder/) {
    $answer_results = "Who's scruffy-looking?";
    if ($answer_results) {
	$answer_type = 'hansolo';
	$type = 'E';
    }
}
