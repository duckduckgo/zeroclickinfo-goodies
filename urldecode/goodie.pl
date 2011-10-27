
# decode the queried url

if (!$type && $q_check =~ m/^urldecode (.*)$/i) {

    sub dec {
	my $url = shift;
	$url =~ tr/+/ /;
	$url =~ s/%([a-fA-F0-9]{2,2})/chr(hex($1))/eg;
	$url =~ s/<!--(.|\n)*-->//g;
	return $url;
    }

    my $url = $1;
    $answer_results = dec($url);

    if ($answer_results) {
	$answer_type = 'decoded url';
	$type = 'E';
    }
}
