use strict;

package DDG::Goodie::WorkdaysBetween;
# ABSTRACT: Give the number of work days between two given dates. Does not
# consider holidays.

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

use Date::Calendar;
use Date::Calendar::Profiles qw($Profiles);

triggers start => "workdays between", "business days between", "work days between", "working days", "workdays from";

zci answer_type => "workdays_between";
zci is_cached   => 0;

my $date_parser = date_parser();

handle remainder => sub {
    my $query = $_;

    my ($start_date, $end_date, @rest) = $date_parser->extract_dates_from_string($query);
    return unless ($start_date && $end_date && !@rest);

    return unless ($start_date && $end_date);

    ($start_date, $end_date) = ($end_date, $start_date) if (DateTime->compare($start_date, $end_date) == 1);

    my $calendar = Date::Calendar->new($Profiles->{US});
    my $workdays = $calendar->delta_workdays($start_date->year(), $start_date->month(), $start_date->day(), $end_date->year(), $end_date->month(), $end_date->day(), 1, 1);

    my $start_str = $date_parser->for_display($start_date);
    my $end_str   = $date_parser->for_display($end_date);

    my $verb = $workdays == 1 ? 'is' : 'are';
    my $number = $workdays == 1 ? 'Workday' : 'Workdays';

    return "There $verb $workdays $number between $start_str and $end_str.",
        structured_answer => {
            data => {
                title    => $workdays,
                subtitle => "Workdays between $start_str - $end_str"
            },
            templates => {
                group => "text"
            }
        };       
};
1;
