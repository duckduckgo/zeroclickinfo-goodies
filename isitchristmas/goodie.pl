use LWP::Simple;
if ($type ne "E" && $q_check =~ m/^is (it|today) christmas.*$/i) {
    sub yn {
	my $result = get("http://isitchristmas.com/");
	$result =~ /(YES|NO)/;
	return ucfirst lc $1;
    }
    $is_memcached = 1;
    $answer_results = yn;
    $answer_results .= ".";
    if ($answer_results) {
	$answer_type = "yes/no";
	$type = "E";
    }
}
