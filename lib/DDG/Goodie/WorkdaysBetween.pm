use strict;

package DDG::Goodie::WorkdaysBetween;
# ABSTRACT: Give the number of work days between two given dates. Does not
# consider holidays.

use DDG::Goodie;
use Date::Calc::Object qw( Date_to_Days Day_of_Week );
use integer;

triggers start => "workdays between";

zci answer_type => "workdays_between";

primary_example_queries 'workdays between 01/31/2000 01/31/2001';
secondary_example_queries 'workdays between 01/31/2000 01/31/2001 inclusive';
description 'Calculate the number of workdays between two dates. Does not consider holidays.';
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

    my $date1 = Date::Calc->new(@dates[2,0,1]);
    my $date2 = Date::Calc->new(@dates[5,3,4]);

    my ($start, $end);
    if ($date1 < $date2) {
        $start = $date1;
        $end = $date2;
    } else {
        $start = $date2;
        $end = $date1;
    }

    my @start_date = $start->date();
    my @end_date = $end->date();

    my $total_days = Date_to_Days( @end_date ) - Date_to_Days( @start_date );
    my $num_weeks = $total_days / 7;

    # Subtract 2 days (Saturday and Sunday), for every week.
    my $workdays = $total_days - ($num_weeks * 2);

    my $weekday_start = Day_of_Week( @start_date );
    my $weekday_end = Day_of_Week( @end_date );

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

    my $start_str = $start->month() . '/' . $start->day() . '/' . $start->year();
    my $end_str = $end->month() . '/' . $end->day() . '/' . $end->year();

    return 'There are ' . $workdays . " workdays between " . $start_str .
        ' and ' . $end_str . $inclusive . '.';
};

1;
