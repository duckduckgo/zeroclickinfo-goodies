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

    my $dt = DateTime->now(time_zone => $loc->time_zone)
        if ($week eq 'current' or $year eq 'current');

    if ($week eq 'current' and $year eq 'current') {
        return "We are in currently in the " . ordinate($dt->week_number) .
                ' week of ' . $dt->year . '.',
            html => 'We are in currently in the ' . $dt->week_number
                    . '<sup>' . ordsuf($dt->week_number) . '</sup>'
                    . ' week of ' . $dt->year . '.';
    } elsif ($year eq 'current') {
        $year = $dt->year();
    }
    my (undef, $month, $day) = Monday_of_Week($week, $year);
    return "The " . ordinate($week) . " week of $year began on " .
        "$months[--$month] " . ordinate($day) . '.',
        html =>"The $week<sup>" . ordsuf($week) . "</sup> week of $year began on " .
            "$months[$month] $day<sup>" . ordsuf($day) . '</sup>.';
};

1;
