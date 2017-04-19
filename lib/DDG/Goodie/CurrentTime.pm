package DDG::Goodie::CurrentTime;
# ABSTRACT: Responds with current time, date, and zone in specified time zone.

use strict;
use warnings;
use DDG::Goodie;
use DateTime;

primary_example_queries "current time in Tokyo", "time in New York";
secondary_example_queries "London time", "what time is it in chicago";

description "Responds with current time, date, and zone in specified time zone.";
name "Current Time";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CurrentTime.pm";
category "calculations";
topics "travel";

#Attribution
attribution github => ["https://github.com/warethis-dev", "warethis-dev"],
            twitter => ["https://twitter.com/warethis", "warethis"];

# Triggers
triggers any => "current time","current time in","time in","time";
triggers start => "time in","what time is it in";
triggers end => "time";

zci is_cached   => 1;
zci answer_type => 'current_time';

##TODO:	REFINE SEARCH FOR VALUES, IE "INDIA" ONLY RETURNS "AMERICA/INDIANAPOLIS"

# Handle statement
handle remainder => sub {
	my @zones = DateTime::TimeZone::all_names;
	my @terms= split / /, shift;
	for(@terms) {
		s/[[:punct:]]//g;
		$_ = ucfirst($_);
	}

	# search the time zones
	my $response;
	my @matches;
	for(@terms) {
		foreach my $zone (@zones) {
			if($zone =~ /$_/) {
				push(@matches,$zone);
			}
		}
	}

	# check if more than one match, sort if so
	my $matchCount = scalar @matches;
	if($matchCount == 1) {
		# one match, return it
		my $time = DateTime->now();
		my $match = $matches[0];	# the desired result
		$time->set_time_zone($match);
		my $len = (length($match) > 18) ? "<br />" : " | ";
		$response .= "Current Time: " . $time->strftime("%I:%M:%S %p %Z | %A, %b %e, %Y") . "$len<span style='font-style:italic;'>$match</span>";
		return $response;
	} elsif($matchCount > 1) {
		# more than one match, figure it out
		my @sorted = sort {length($a) <=> length($b)} @matches;
		my %seen;
		my @dupes;
		foreach my $strZone (@sorted) {
		    next unless $seen{$strZone}++;
		    push(@dupes, $strZone);
		}
		my $dupeCount = scalar @dupes;
		if($dupeCount == 1) {	
			my $time = DateTime->now();
			my $match = $dupes[0];	# return first duplicate match - probable desired result
			$time->set_time_zone($match);
			my $len = (length($match) > 18) ? "<br />" : " | ";
			$response .= "Current Time: " . $time->strftime("%I:%M:%S %p %Z | %A, %b %e, %Y") . "$len<span style='font-style:italic;'>$match</span>";
			return $response;
		} else {	# multiple matches with no dupes, deal with that
			my $time = DateTime->now();
			my $match = $sorted[0];	# return first match - still considering how best to proceed in determining best result from multiple match
			$time->set_time_zone($match);
			my $len = (length($match) > 18) ? "<br />" : " | ";
			$response .= "Current Time: " . $time->strftime("%I:%M:%S %p %Z | %A, %b %e, %Y") . "$len<span style='font-style:italic;'>$match</span>";
			return $response;
		}
	} else {
		# no matches, get outta here
		return;
	}

	# move along, nothing to see here
	return;
};

1;
