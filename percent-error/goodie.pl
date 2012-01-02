
# Outputs the percent-error of the given values.

if (!$type && $q_check =~ m/^(?:percent|%)(?: |-|)(?:err|error) ([\-?0-9.]+) ([\-?0-9.]+)$/i) {
    my $acc = $1;
    my $exp = $2;
    my $diff = abs $acc - $exp;
    my $err = abs ($diff/$acc*100);
    
    $answer_results = qq(Accepted: $acc\nExperimental: $exp\nError: $err%);
    if ($answer_results) {
	$answer_type = 'percent-error';
	$type = 'E';
    }
}
