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

my $datestring_regex = datestring_regex();

handle remainder => sub {
    my $query = $_;

    return unless ($query =~ qr/($datestring_regex) (?:(?:and|to) )?($datestring_regex)/i);
    my ($start_date, $end_date) = parse_all_datestrings_to_date($1, $2);

    return unless ($start_date && $end_date);

    ($start_date, $end_date) = ($end_date, $start_date) if (DateTime->compare($start_date, $end_date) == 1);

    my $calendar = Date::Calendar->new($Profiles->{US});
    my $workdays = $calendar->delta_workdays($start_date->year(), $start_date->month(), $start_date->day(), $end_date->year(), $end_date->month(), $end_date->day(), 1, 1);

    my $start_str = date_output_string($start_date);
    my $end_str   = date_output_string($end_date);

    my $verb = $workdays == 1 ? 'is' : 'are';
    my $number = $workdays == 1 ? 'Workday' : 'Workdays';

    return "There $verb $workdays $number between $start_str and $end_str",
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
