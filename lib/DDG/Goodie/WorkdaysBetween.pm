use strict;

package DDG::Goodie::WorkdaysBetween;
# ABSTRACT: Give the number of work days between two given dates. Does not
# consider holidays.

use DDG::Goodie;
use Date::Calc::Object qw( Date_to_Days Day_of_Week );
use Time::Piece;
use List::Util qw( min max );

triggers start => "workdays between", "business days between";

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
    my ($start, $end) = get_dates($_);

    # If get_dates failed, return nothing.
    unless ($start && $end) {
        return;
    }

    my $inclusive = '';

    my @start_date = $start->date();
    my @end_date = $end->date();

    my $total_days = Date_to_Days( @end_date ) - Date_to_Days( @start_date );

    my $num_weeks = int($total_days / 7);

    # For every 7 days there will always be 1 Saturday and 1 Sunday, therefore
    # we subtract 2 days for every full week in the range.
    my $workdays = $total_days - ($num_weeks * 2);

    # Find the remaining number of days that didn't fall into the full weeks
    # we already counted.
    my $remainder = $total_days % 7;

    # Adding the starting weekday to the number of remainder days allows us to
    # determine whether or not the remainder days contain a Saturday and/or a
    # Sunday.
    my $weekday_start = Day_of_Week( @start_date );
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

# Given a string containing two dates, parse out the dates, and return them in
# chronological order.
#
# On success this subroutine returns a two element array of
# Date::Calc::Objects in the following format ( $start_date, $end_date )
#
# On failure this function returns nothing.
sub get_dates {
    my @date_strings = $_ =~ m#(\d{1,2}/\d{1,2}/\d{4}|\w{3} \d{1,2},? \d{4})#g;

    # A list of date formats to try sequentially.
    my @date_formats = ( "%m/%d/%Y", "%d/%m/%Y", "%b %d %Y", "%b %d, %Y" );

    # If we don't have two dates matching the correct format, return nothing.
    if (scalar(@date_strings) != 2) {
        return;
    }

    # Populate the @dates array. With Date::Calc::Objects
    my @dates;
    foreach (@date_strings) {
        my $date_string = $_;
        foreach (@date_formats) {
            local $@;
            eval {
                # Attempt to parse the date here.
                my $time = Time::Piece->strptime($date_string, $_);

                # If the format was acceptable, add the date to the @dates array
                push(@dates,
                    Date::Calc->new($time->year, $time->mon, $time->mday));
            };

            # Break the loop unless we had an eval error
            unless ($@) { last; }
        }
    }

    # Bail out if we don't have exactly two dates.
    if (scalar(@dates) != 2) {
        return;
    }

    # Find the start and end dates.
    my $start = min(@dates);
    my $end = max(@dates);

    return ($start, $end);
}

1;
