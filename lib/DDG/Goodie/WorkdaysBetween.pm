use strict;

package DDG::Goodie::WorkdaysBetween;
# ABSTRACT: Give the number of work days between two given dates.

use DDG::Goodie;
use Date::Calc qw( Date_to_Days Day_of_Week );
use integer;

triggers start => "workdays between";

zci is_cached => 1;
zci answer_type => "workdays_between";

primary_example_queries 'workdays between 01/31/2000 01/31/2001';
secondary_example_queries 'workdays between 01/31/2000 01/31/2001 inclusive';
description 'calculate the number of days between two dates';
name 'WorkDaysBetween';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/WorkdaysBetween.pm';
category 'calculations';
topics 'everyday';
attribution github => ['http://github.com/mgarriott', 'mgarriott'];

handle remainder => sub {

    my @dates = $_ =~ m#([01]?[0-9])/([0-3]?[0-9])/([0-9]{4}(?=\s|$))#g;

    if (scalar(@dates) != 6) {
        # Abandon, we don't know how to parse this
        return;
    }

    my $inclusive = '';
    my $start = Date_to_Days(@dates[2,0,1]);
    my $end = Date_to_Days(@dates[5,3,4]);

    my $total_days = $end - $start;
    my $num_weeks = $total_days / 7;

    # Subtract 2 days (Saturday and Sunday), for every week.
    my $workdays = $total_days - ($num_weeks * 2);

    my $weekday_start = Day_of_Week(@dates[2,0,1]);
    my $weekday_end = Day_of_Week(@dates[5,3,4]);

    my $remainder = $total_days % 7;
    my $start_plus_remainder = $weekday_start + $remainder;

    # If the remaining days contain a Sunday we need to remove it from
    # the count. But only if Saturday isn't the starting date, else it
    # won't be included by default
    $workdays-- if $weekday_start < 6 && ($start_plus_remainder) > 5;

    # If the remaining days contain a Sunday we need to remove it from
    # the count. However, we only want to remove this if the starting date
    # is NOT a Sunday.
    $workdays-- if $weekday_start < 7 && ($start_plus_remainder) > 6;

    # Ignore 'inclusive' if the start date is a Saturday or Sunday.
    # Otherwise we will add 1 day to the total, and include the
    # 'inclusive' note in the resulting string.
    if ($weekday_start < 6 && /inclusive/) {
        $workdays += 1;
        $inclusive = ', inclusive';
    }

    my $start_date = join '/', @dates[0,1,2];
    my $end_date = join '/', @dates[3,4,5];

    return 'There are ' . $workdays . " workdays between " . $start_date .
        ' and ' . $end_date . $inclusive . '.';
};

1;
