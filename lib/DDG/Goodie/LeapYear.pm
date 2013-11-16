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
handle remainder => sub {
    my ($second, $minute, $hour, $dayOfMonth, $month, $partyear, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
    my $year = $partyear + 1900;
    if ($_ =~ /(last|previous) ([0-9]?[0-9])/) {
        my @years = ();
        my $numdone = 0;
        $year --;
        while($numdone < $2) {
            while(!isleap($year)) {
                $year--;
            }
            $years[$numdone++] = $year--;
        }
        my @pretty_years = join(', ', @years);
        return "The last $2 leap years were @pretty_years";
    } elsif ($_ =~ /next ([0-9]?[0-9])/) {
        my @years = ();
        my $numdone = 0;
        $year ++;
        while($numdone < $1) {
            while(!isleap($year)) {
                $year++;
            }
            $years[$numdone++] = $year++;
        }
        my @pretty_years = join(', ', @years);
        return "The next $1 leap years are @pretty_years";
    } elsif ($_ =~ /next/) {
        $year ++;
        while(!isleap($year)) {
            $year ++;
        }
        return "$year is the next leap year";
    } elsif ($_ =~ /last|previous/) {
        $year --;
        while(!isleap($year)) {
            $year--;
        }
        return "$year was the last leap year";
    } elsif($_ =~ /([0-9]+) ?(ad|bce|bc|ce)?/i) {
        my $cyear = $1;
        my $postfix = $2;
        if(! defined($2) || $postfix =~ /(ce|ad)/i) {
            $postfix = "CE";
        } elsif($postfix =~ /(bce|bc)/i) {
            $postfix = "BCE";
            $cyear = -$cyear;
        }
        my $format_year = abs($cyear);
        $postfix = uc($postfix);
        if(isleap($cyear)) {
            return "$format_year $postfix is a leap year";
        } else {
            return "$format_year $postfix is not a leap year";
        }
    } else {
        if(isleap($year)) {
            return "$year is a leap year";
        } else {
            return "$year is not a leap year";
        }
    }
    return;
};

1;
