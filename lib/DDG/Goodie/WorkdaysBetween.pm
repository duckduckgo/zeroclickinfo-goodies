use strict;

package DDG::Goodie::WorkdaysBetween;
# ABSTRACT: Give the number of work days between two given dates. Does not
# consider holidays.

use DDG::Goodie;
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

    my $total_days = int( $end->mjd ) - int( $start->mjd );
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
    
    my $weekday_start = $start->_wday;
    if($start->_wday == 0) {
	$weekday_start = 7;
    }

    my $start_plus_remainder = $weekday_start + $remainder;

    # If the remaining days contain a Saturday we need to remove it from
    # the count. But only if Saturday isn't the starting date, else it
    # won't be included by default.
    $workdays-- if $weekday_start < 6 && ($start_plus_remainder) > 5;

    # If the remaining days contain a Sunday we need to remove it from
    # the count. However, we only want to remove this if the starting date
    # is NOT a Sunday.
    $workdays-- if $weekday_start < 7 && ($start_plus_remainder) > 6;
    
    if($weekday_start == 6 || $weekday_start == 7) {
	$workdays--;
    }

    # Ignore 'inclusive' if the start date is a Saturday or Sunday.
    # Otherwise we will add 1 day to the total, and include the
    # 'inclusive' note in the resulting string.
    if (/inclusive/) {
        $workdays += 1;
        $inclusive = ', inclusive';
    }

    my $date_format = "%b %d, %Y";
    my $start_str = $start->strftime($date_format);
    my $end_str = $end->strftime($date_format);

    return 'There are ' . $workdays . " workdays between " . $start_str .
        ' and ' . $end_str . $inclusive . '.';
};

# Given a string containing two dates, parse out the dates, and return them in
# chronological order.
#
# On success this subroutine returns a two element array of
# Time::Piece in the following format ( $start_date, $end_date )
#
# On failure this function returns nothing.
sub get_dates {
    my @date_strings = $_ =~ m#(\d{1,2}/\d{1,2}/\d{4}|\w{3} \d{1,2},? \d{4})#g;

    # If we don't have two dates matching the correct format, return nothing.
    if (scalar(@date_strings) != 2) {
        return;
    }

    # A list of date formats to try sequentially.
    my $day_first_format = "%d/%m/%Y";
    my @date_formats = ( "%m/%d/%Y", $day_first_format, "%b %d %Y", "%b %d, %Y" );

    # Flag that determines if we are using the DD/MM/YYYY format
    my $day_is_first = 0;

    # Populate the @dates array. With Time::Piece
    my @dates;
    for (my $i = 0; $i < scalar(@date_strings); $i++) {
        my $date_string = $date_strings[$i];
        foreach (@date_formats) {
            local $@;

            my $time;
            eval {
                # Attempt to parse the date here.
                $time = Time::Piece->strptime($date_string, $_);
            };

            # If we didn't get an error parsing the time...
            unless ($@) {

                # If a date matches the DD/MM/YYYY format we want to ensure
                # that all the XX/XX/XXXX dates match that specific format.
                # Therefore, we remove the MM/DD/YYYY format from the
                # dates_format array, clear the dates array, and restart the
                # loop. This way all XX/XX/XXXX dates will match only the
                # DD/MM/YYYY format.
                if ( $_ eq $day_first_format && !$day_is_first ) {
                    # Set the flag indicating that we are using DD/MM/YYYY
                    $day_is_first = 1;
                    # Remove the MM/DD/YYYY format from the date_formats array
                    shift(@date_formats);
                    # Empty the @dates array
                    undef @dates;
                    # Reset the loop index
                    $i = -1;
                    # Restart the loop iteration
                    next;
                }

                # If the format was acceptable, add the date to the @dates array
                push(@dates, $time);
                last;
            }
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
