use strict;

package DDG::Goodie::WeekdaysBetween;
# ABSTRACT: Give the number of week days between two given dates.

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

triggers start => "weekdays between", "week days between", "weekdays from", "week days from";

zci answer_type => "weekdays_between";
zci is_cached   => 0;

name                        'WeekdaysBetween';
description                 'Calculate the number of weekdays between two dates.';
category                    'calculations';
topics                      'everyday';
primary_example_queries     'weekdays between 01/31/2000 01/31/2001';
code_url                    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/WeekdaysBetween.pm';
attribution                 github => ['syst3mw0rm', 'Aamir Khan'],
                            email => ['syst3m.w0rm@gmail.com', 'Aamir Khan'];

my $datestring_regex = datestring_regex();

handle remainder => sub {
    return unless $_ =~ qr/^($datestring_regex) (?:(?:and|to) )?($datestring_regex)/i;
    my ($start, $end) = (parse_datestring_to_date($1), parse_datestring_to_date($2));
    return unless ($start && $end);

    # Flip if the dates are the wrong way around
    ($end, $start) = ($start, $end) if ( DateTime->compare($start, $end) == 1 );

    my $weekday_count = delta_weekdays($start, $end);

    my $start_str = date_output_string($start);
    my $end_str   = date_output_string($end);

    my $verb = $weekday_count == 1 ? 'is' : 'are';
    my $weekday_plurality = $weekday_count == 1 ? 'Weekday' : 'Weekdays';

    my $response = "There $verb $weekday_count $weekday_plurality between $start_str and $end_str.";

    return $response,
      structured_answer => {
        input     => [$start_str, $end_str],
        operation => "$weekday_plurality between",
        result    => $weekday_count
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
