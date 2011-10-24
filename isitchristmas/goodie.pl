use LWP::Simple;
if ($type ne "E" && $q_check =~ m/^is (it|today) christmas.*$/i) {
    sub yn {
	my $result = get("http://isitchristmas.com/");
	$result =~ /(YES|NO)/;
	return ucfirst lc qq($1. );
    }
    $is_memcached = 1;
    my $response = yn;
    my $phrase = ($response eq "No. ") ? "It's not Christmas. No gifts for you." : "It's Christmas!!!";
    $answer_results = ($response .= $phrase);
    if ($answer_results) {
	$answer_type = "yes/no";
	$type = "E";
    }
}
