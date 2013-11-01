package DDG::Goodie::LeapYear;
# ABSTRACT: Check if a year is leap year
use DDG::Goodie;
use Date::Leapyear;

zci answer_type => "leap_year";

primary_example_queries 'is it a leap year';
secondary_example_queries 'when is the next leap year';
description 'Check if it is a leap year';
name 'Leap year';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/LeapYear.pm';
category 'calculations';
topics 'everyday';
attribution github => [ 'https://github.com/tophattedcoder', 'Tom Bebbington'];

triggers startend => 'leap year';
handle remainder => sub {
    my ($second, $minute, $hour, $dayOfMonth, $month, $partyear, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
    my $year = $partyear + 1900; 
    if (index($_, "next") != -1) {
        $year ++;
        while(!isleap($year)) {
            $year ++;
        }
        return "$year is the next leap year";
    } elsif (index($_, "last") != -1) {
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
