use strict;

package DDG::Goodie::WeekdaysBetween;
# ABSTRACT: Give the number of week days between two given dates.

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

triggers start => "weekdays between", "week days between", "weekdays from", "week days from";
zci answer_type => "weekdays_between";

primary_example_queries 'weekdays between 01/31/2000 01/31/2001';
description 'Calculate the number of weekdays between two dates.';
name 'WeekdaysBetween';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/WeekdaysBetween.pm';
category 'calculations';
topics 'everyday';
attribution github => ['http://github.com/syst3mw0rm', 'syst3mw0rm'];

my $date_regex = date_regex();

handle remainder => sub {
    return unless $_ =~ qr/^($date_regex) (?:(?:and|to) )?($date_regex)/i;
    my ($start, $end) = (parse_string_to_date($1), parse_string_to_date($2));
    return unless ($start && $end);
    
    # Flip if the dates are the wrong way around
    ($end, $start) = ($start, $end) if ( DateTime->compare($start, $end) == 1 );

    my $weekdays = delta_weekdays($start, $end);
    
    my $date_format = "%d %b %Y";
    my $start_str = $start->strftime($date_format);
    my $end_str = $end->strftime($date_format);

    my $verb = $weekdays == 1 ? 'is' : 'are';
    my $number = $weekdays == 1 ? 'weekday' : 'weekdays';

    return "There $verb $weekdays $number between $start_str and $end_str.";
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