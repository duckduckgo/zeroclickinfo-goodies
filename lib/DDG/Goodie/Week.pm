package DDG::Goodie::Week;
# ABSTRACT: Give information about the week query typed in

use DDG::Goodie;

# My imports
use strict;
use warnings;
use DateTime;
use Date::Calc qw(:all);

# File metadata
primary_example_queries "week current";
secondary_example_queries "week 8", "week 14 1988";
description "find the current week number or when a random week began";
name "Week";
code_url "https://github.com/gsquire/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Week.pm";
category "dates";
topics "everyday", "special_interest";
attribution twitter => "garrettsquire",
						github => "gsquire";

triggers start => "week";

handle remainder => sub {
	
	my $input = $_; # Named variables are better
	my $dt = DateTime->now(time_zone => "local");

	if ($input eq "current") {
		return "We are in week number " . $dt->week_number;
	}

	elsif ($input =~ /^(\d{1,2})$/) {

		my $year = $dt->year();
		my $week_num = $1;

		return if $week_num > 52;
		
		my (undef, $month, $day) = Monday_of_Week($week_num, $year);

		return "Week $week_num started on $month-$day in $year";
		
	}

	elsif ($input =~ /^(\d{1,2})\s+(\d{4})$/) {

		my $week_num = $1;
		my $year = $2;

		return if $week_num > 52;

		my (undef, $month, $day) = Monday_of_Week($week_num, $year);

		return "Week $week_num started on $month-$day of $year";

	}

	else {
		return;
	}

};

zci is_cached => 1;
zci answer_type => "week";

1;


