package DDG::Goodie::Week;
# ABSTRACT: Find the current week number or when a week began

use DDG::Goodie;

# My imports
use strict;
use warnings;
use Lingua::EN::Numbers::Ordinate qw/ordinate ordsuf/;
use DateTime;
use Date::Calc qw(:all);

# File metadata
primary_example_queries "what is the current week";
secondary_example_queries "what was the 5th week of this year",
                          "what was the 5th week of 1944";
description "find the current week number or when a week began";
name "Week";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Week.pm";
category "dates";
topics "everyday", "special_interest";
attribution twitter => ["garrettsquire", 'Garrett Squire'],
            github => ["gsquire", 'Garrett Squire'];

triggers any => 'week';

zci is_cached => 1;
zci answer_type => "week";

my @months = qw/
    January
    February
    March
    April
    May
    June
    July
    August
    September
    October
    November
    December
/;

handle query_raw => sub {
    return unless /^\s*
        what(?:'?s|\sis|\swas)?\s+
        (?:the\s+)?
        (?:(current|(\d{1,2})(?:nd|th|rd|st)?)\s+)?
        week
        (
            \s+of\s+
            (?:(?:the|this)\s+)?
            (year|\d{4})
            |
            \s+is\s+this
        )?\??
    \s*$/x;

    my $week = $1;
    my $year = defined $4 ? ($4 eq 'year' ? 'current' : $4) : 'current';
    ($week, $year) = qw/current current/ if (not defined $week);

    return if $week =~ s/(nd|th|rd|st)$// and $week > 52;

    my $dt = DateTime->now(time_zone => $loc->time_zone) if ($week eq 'current' or $year eq 'current');

    my ($response, $operation);

    if ($week eq 'current' and $year eq 'current') {
        my ($dt_week_num, $dt_year) = (ordinate($dt->week_number), $dt->year);
        $response = "We are currently in the $dt_week_num week of $dt_year.";
        $operation = "Current week";
    } elsif ($year eq 'current') {
        $year = $dt->year();
    }

    unless ($response){
        my (undef, $month, $day) = Monday_of_Week($week, $year);
        my ($week_num, $day_num, $out_month) = (ordinate($week), ordinate($day), $months[--$month]);

        $response = "The $week_num week of $year began on $out_month $day_num.";
        $operation = "Find the $week_num week of $year";
    }

    return $response,
      structured_answer => {
        input     => [],
        operation => "Assuming the week starts on Monday",
        result    => $response
      };
};

1;
