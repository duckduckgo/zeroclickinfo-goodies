use strict;

package DDG::Goodie::WeekdaysBetween;
# ABSTRACT: Give the number of week days between two given dates.

use DDG::Goodie;
use List::Util qw( min max );
use Date::Calc qw(Delta_Days Day_of_Week);

triggers start => "weekdays between", "week days between", "weekdays from", "week days from";

zci answer_type => "weekdays_between";

name                        'WeekdaysBetween';
description                 'Calculate the number of weekdays between two dates.';
category                    'calculations';
topics                      'everyday';
primary_example_queries     'weekdays between 01/31/2000 01/31/2001';
code_url                    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/WeekdaysBetween.pm';
attribution                 github => ['http://github.com/syst3mw0rm'],
                            email => ['syst3m.w0rm@gmail.com'];

my $css = share('style.css')->slurp;

# Wrap the response in html so that it can be styled with css
sub html_output {
    my ($weekday_count, $start_end_dates) = @_;
    return "<style type='text/css'>$css</style>"
          ."<div class='zci--weekdaysbetween'>"
          ."<span class='text--primary'>$weekday_count</span><br/>"
          ."<span class='text--secondary'>$start_end_dates</span>"
          ."</div>";
}


handle remainder => sub {
    my ($start, $end) = get_dates($_);

    # If get_dates failed, return nothing.                                                                                                                                                                                                                                                                                                                                  
    return unless ($start && $end);

    my $weekday_count = delta_weekdays($start->year, $start->mon, $start->mday, $end->year, $end->mon, $end->mday);
    
    my $date_format = "%b %d, %Y";
    my $start_str = $start->strftime($date_format);
    my $end_str = $end->strftime($date_format);

    my $verb = $weekday_count == 1 ? 'is' : 'are';
    my $weekday_plurality = $weekday_count == 1 ? 'weekday' : 'weekdays';

    my $response = "There $verb $weekday_count $weekday_plurality between $start_str and $end_str.";

    return $response, html => html_output("$weekday_count $weekday_plurality", "between $start_str and $end_str.");
};

# It calculates the number of weekdays between two given dates, both inclusive.
sub delta_weekdays {
  my(@date1) = ($_[0], $_[1], $_[2]);
  my(@date2) = ($_[3], $_[4], $_[5]);
  my($day_count,$result,$dow1,$dow2,$wholeweeks,$temp);

  $day_count = Delta_Days(@date1, @date2) + 1; # always inclusive
  if ($day_count != 0) {
        if ($day_count < 0) {
          return;
        }
        else {
            $dow1 = Day_of_Week(@date1);
        }
        
        $wholeweeks = int($day_count / 7);
        $result = $wholeweeks * 5;
        $temp = $day_count - $wholeweeks * 7;
        
        $dow2 = $dow1 - 1 + $temp;
        if($dow2 > 7) {
          $dow2 -= 7;
        }
        for(;;) {
            if($dow1 < 6) {
              $result = $result + 1;
            }
            if($dow1 == $dow2) {
              last;
            }
            $dow1 = $dow1 + 1;
            if($dow1 > 7) {
              $dow1 = $dow1 - 7;
            }
        }
  }
  return  $result;
}

# Copied from https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/WorkdaysBetween.pm#L48-#L132
# Given a string containing two dates, parse out the dates, and return them in
# chronological order.
#
# On success this subroutine returns a two element array of
# Time::Piece in the following format ( $start_date, $end_date )
#
# On failure this function returns nothing.
sub get_dates {
    my @date_strings = $_ =~ m#(\d{1,2}/\d{1,2}/\d{2,4}|\w{0,9} \d{1,2},? \d{2,4}|\d{1,2}-\d{1,2}-\d{2,4}|\d{1,2}\.\d{1,2}\.\d{2,4})#gi;

    # If we don't have two dates matching the correct format, return nothing.
    if (scalar(@date_strings) != 2) {
        return;
    }

    # A list of date formats to try sequentially.
    my $day_format_slash = "%d/%m/";
    my $day_format_dash = "%d-%m-";
    my $day_format_period = "%d.%m.";
    my @date_formats = ( "%m/%d/", "%m-%d-", "%m.%d.", $day_format_slash, $day_format_dash, $day_format_period, "%b %d ", "%b %d, ", "%B %d ", "%B %d, ");

    # Flag that determines if we are using the DD/MM/YYYY format
    my $day_is_first = 0;

    # Populate the @dates array. With Time::Piece
    my @dates;
    for (my $i = 0; $i < scalar(@date_strings); $i++) {
        my $date_string = $date_strings[$i];
        foreach (@date_formats) {
            local $@;

            # Check to see if we're using the shortened year format or not.
            my $year_format = '%y';
            if($date_string =~ /\d{4}$/) {
                $year_format = '%Y';
            }

            my $time;
            eval {
                # Attempt to parse the date here.
                my $parsing_format = "$_$year_format";
                $time = Time::Piece->strptime( $date_string, $parsing_format );

                # When we parse date like Feb 30th, Time::Piece will automatically correct to Mar 2nd
                # which we don't want it to happen, preventing by comparing string before and after parsing
                my $before_parsing = normalizer( $date_string );
                my $after_parsing = normalizer( $time->strftime($parsing_format) );
                die 'Found invalid date' if $before_parsing ne $after_parsing;
            };

            # If we didn't get an error parsing the time...
            unless ($@) {

                # If a date matches the DD/MM/YYYY format we want to ensure
                # that all the XX/XX/XXXX dates match that specific format.
                # Therefore, we remove the MM/DD/YYYY format from the
                # dates_format array, clear the dates array, and restart the
                # loop. This way all XX/XX/XXXX dates will match only the
                # DD/MM/YYYY format.
                if ( ($_ eq $day_format_slash || $_ eq $day_format_dash || $_ eq $day_format_period) && !$day_is_first ) {
                    # Set the flag indicating that we are using DD/MM/YYYY
                    $day_is_first = 1;

                    # Remove the formats in the array that begin with the month.
                    shift(@date_formats) for(1 .. 3);

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

# This submodule intends to compare $time like 6/4/2014 with 06/04/2014 easier
# What it does is
# - Pad 0 for single number
# - Convert str to lowercase since strftime() return capitalized month
sub normalizer {
    my $str_time = shift;
    my @dt = split( /,|-|\s|\//, $str_time );

    for ( my $i = 0; $i < scalar @dt; $i++ ) {
        my $item = $dt[$i];

        if( $item =~ /^\d$/ ) {
            $dt[$i] = "0$item";
        }
    }

    return lc join( '-', @dt );
}

1;
