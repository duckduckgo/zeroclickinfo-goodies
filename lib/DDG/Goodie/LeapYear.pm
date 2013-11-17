package DDG::Goodie::LeapYear;
# ABSTRACT: Check if a year is leap year
use DDG::Goodie;
use Date::Leapyear;
use strict;
use warnings;

zci answer_type => "leap_year";

primary_example_queries 'is it a leap year';
secondary_example_queries 'when is the next leap year';
description 'Check if it is a leap year';
name 'Leap year';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/LeapYear.pm';
category 'calculations';
topics 'everyday';
attribution github => [ 'https://github.com/tophattedcoder', 'Tom Bebbington'];

triggers startend => 'leap years', 'leap year';
my %is_tense = (
    past => 'was',
    present => 'is',
    future => 'will be',
);
my %is_not_tense = (
    past => 'was not',
    present => 'is not',
    future => 'will not be',
);
my ($second, $minute, $hour, $dayOfMonth, $month, $partyear, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
my $year = $partyear + 1900;
sub search_leaps {
    my $num = shift;
    my $direction = shift;
    my $include_curr = shift;
    my @years = ();
    my $numdone = 0;
    my $cyear = $year;
    if($include_curr eq 0) {
        $cyear += $direction;
    }
    while($numdone < $num) {
        while(!isleap($cyear)) {
            $cyear += $direction;
        }
        $years[$numdone++] = $cyear;
        $cyear += $direction;
    }
    return @years;
}
sub find_tense {
    my $cyear = shift;
    if($cyear < $year) {
        return "past";
    } elsif($cyear > $year) {
        return "future";
    } else {
        return "present";
    }
}
sub format_year {
    my $cyear = shift;
    if(!defined($cyear)) {
        $cyear = $_;
    }
    if($cyear < 0) {
        $cyear = abs($cyear);
        return "$cyear BCE";
    } else {
        return "$cyear CE";
    }
}
handle remainder => sub {
    if ($_ =~ /(last|previous) ([0-9]+)/) {
        my @years = search_leaps($2, -1, 0);
        @years = map(format_year, @years);
        my @pretty_years = join(', ', @years);
        return "The last $2 leap years were @pretty_years";
    } elsif ($_ =~ /(next|future) ([0-9]+)/) {
        my @years = search_leaps($2, 1, 0);
        @years = map(format_year, @years);
        my @pretty_years = join(', ', @years);
        return "The $1 $2 leap years will be @pretty_years";
    } elsif ($_ =~ /(next|future|upcoming)/) {
        my ($nyear) = search_leaps(1, 1, 0);
        $nyear = format_year($nyear);
        return "$nyear will be the $1 leap year";
    } elsif ($_ =~ /(latest|last|previous)/) {
        my ($pyear) = search_leaps(1, -1, 0);
        $pyear = format_year($pyear);
        return "$pyear was the $1 leap year";
    } elsif ($_ =~ /(most recent)/) {
        my ($ryear) = search_leaps(1, -1, 1);
        $ryear = format_year($ryear);
        return "$ryear is the $1 leap year";
    } elsif($_ =~ /(\-?[0-9]+) ?(ad|bce|bc|ce)?/i) {
        my $cyear = $1;
        if(defined($2) && $2 =~ /(bce|bc)/i) {
            $cyear = -$cyear;
        }
        my $fyear = format_year($cyear);
        my $tense = find_tense($cyear);
        if(isleap($cyear)) {
            return "$fyear $is_tense{$tense} a leap year";
        } else {
            return "$fyear $is_not_tense{$tense} a leap year";
        }
    } elsif($_ =~ /current|now|this year|is it (currently )?a|are we in a/) {
        my $fyear = format_year($year);
        if(isleap($year)) {
            return "$fyear is a leap year";
        } else {
            return "$fyear is not a leap year";
        }
    }
    return;
};

1;
