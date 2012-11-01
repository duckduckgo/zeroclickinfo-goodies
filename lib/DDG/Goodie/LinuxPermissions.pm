package DDG::Goodie::LinuxPermissions;

use DDG::Goodie;

triggers query_lc => qr/^([0|1|2|4]{1}][0-7]{3}$/

handle matches => sub {
	@perm = split(//);
	my ($result) = @_ . "\n\nUser: " . &calculate(@_[1]) . "\n";
	$result .= "Group: " . &calculate(@_[2]) . "\n";
	$result .= "Others: " . &calculate(@_[3]);
	return $result;
}

sub calculate {
	if($_[0] == 7)
		return "Read, Write, and Execute";
	else if($_[0] == 6)
		return "Read and Write";
	else if($_[0] == 5)
		return "Read and Execute";
	else if($_[0] == 4)
		return "Read";
	else if($_[0] == 3)
		return "Write and Execute";
	else if($_[0] == 2)
		return "Write";
	else if($_[0] == 1)
		return "Execute";
	else return "No access";
}
