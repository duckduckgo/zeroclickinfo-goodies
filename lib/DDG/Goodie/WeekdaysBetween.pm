use strict;

package DDG::Goodie::WeekdaysBetween;
# ABSTRACT: Give the number of week days between two given dates.

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

triggers start => "weekdays between", "week days between", "weekdays from", "week days from";

zci answer_type => "weekdays_between";
zci is_cached   => 0;

my $date_parser;

handle remainder => sub {
    my $query = shift;
    my $date_parser = date_parser();
    my ($start, $end, @rest) = $date_parser->extract_dates_from_string($query) or return;
    return unless ($start && $end && !@rest);

    # Flip if the dates are the wrong way around
    ($end, $start) = ($start, $end) if ( DateTime->compare($start, $end) == 1 );

    my $weekday_count = delta_weekdays($start, $end);

    my $start_str = $date_parser->format_date_for_display($start);
    my $end_str   = $date_parser->format_date_for_display($end);

    my $verb = $weekday_count == 1 ? 'is' : 'are';
    my $weekday_plurality = $weekday_count == 1 ? 'Weekday' : 'Weekdays';

    my $response = "There $verb $weekday_count $weekday_plurality between $start_str and $end_str.";

    return $response,
    	structured_answer => {
            data => {
            	title    => $weekday_count,
            	subtitle => "$weekday_plurality between $start_str - $end_str",
        	},
        	templates => {
            	group => "text"
            }
      	};
};

# It calculates the number of weekdays between two given dates, both inclusive.
sub delta_weekdays {
    my ($start, $end) = @_;
    my($day_count, $result, $dow1, $dow2, $wholeweeks, $temp);
    my $difference = $start->delta_days($end);

    $day_count = $difference->in_units('days') + 1; # always inclusive
    return 0 unless $day_count > 0 ;

    $dow1 = $start->day_of_week();

    $wholeweeks = int($day_count / 7);
    $result = $wholeweeks * 5;
    $temp = $day_count - $wholeweeks * 7;

    $dow2 = $dow1 - 1 + $temp;

    $dow2 -= 7 if($dow2 > 7);

    for(;;) {
        $result = $result + 1 if($dow1 < 6);
        last if($dow1 == $dow2);
        $dow1 = $dow1 + 1;
        $dow1 = $dow1 - 7 if($dow1 > 7);
    }

    return $result;
}

1;
