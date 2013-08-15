package DDG::Goodie::Week;
# ABSTRACT: Give information about the week query typed in

use DDG::Goodie;

# My imports
use strict;
use warnings;
use Lingua::EN::Numbers::Ordinate;
use DateTime;
use Date::Calc qw(:all);

# File metadata
primary_example_queries "what is the current week";
secondary_example_queries "what was the 5th week of this year",
                          "what was the 5th week of 1944";
description "find the current week number or when a random week began";
name "Week";
code_url "https://github.com/gsquire/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Week.pm";
category "dates";
topics "everyday", "special_interest";
attribution twitter => "garrettsquire",
						github => "gsquire";

triggers start => "what is the current", "what was the";

handle remainder => sub {

  my %months = (
    1 => "January",
    2 => "February",
    3 => "March",
    4 => "April",
    5 => "May",
    6 => "June",
    7 => "July",
    8 => "August",
    9 => "September",
    10 => "October",
    11 => "November",
    12 => "December"
    );
  
  my $cur_st = " week of this year"; # For regex options
  my $var_st = " week of ";
  
	my $input = $_; # Named variables are better
	my $dt = DateTime->now(time_zone => "local");

	if ($input eq "week") {
		return "We are in currently in the " . ordinate($dt->week_number) .
		  " week of " . $dt->year();
	}

	elsif ($input =~ /(\d{1,2})(?:rd|nd|st|th)$cur_st/) {

		my $year = $dt->year();
		my $week_num = $1;

		return if $week_num > 52;
		
		my (undef, $month, $day) = Monday_of_Week($week_num, $year);

		return "The " . ordinate($week_num) . " week of $year began on " .
		  $months{$month} . " " . ordinate($day);
		
	}

	elsif ($input =~ /(\d{1,2})(?:rd|nd|st|th)$var_st(\d{1,4})/) {

		my $week_num = $1;
		my $year = $2;

		return if $week_num > 52;

		my (undef, $month, $day) = Monday_of_Week($week_num, $year);

		return "The " . ordinate($week_num) . " week of $year began on " .
		  $months{$month} . " " . ordinate($day);
	}

	else {
		return;
	}

};

zci is_cached => 1;
zci answer_type => "week";

1;
