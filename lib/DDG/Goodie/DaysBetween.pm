package DDG::Goodie::DaysBetween;
# ABSTRACT: Give the number of days between two given dates.

use strict;
use DDG::Goodie;
use DateTime;
with 'DDG::GoodieRole::Dates';

triggers start => "days between", "days", "daysbetween", "days_between", "number of days between", "how many days between", "number of days from", "days from", "days since", "how many days since", "number of days since", "days until";

# 'Days since' will calculate days from the specified date to the present date, therefore answer cannot be cached
zci is_cached => 0;
zci answer_type => "days_between";

my $datestring_regex = datestring_regex();
my @months  = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );

handle remainder => sub {
    return unless ($_ =~ qr/^($datestring_regex) (?:(?:and|to|until) )?($datestring_regex)(?:[,]? inclusive)?$/i) || ($_ =~ qr/^($datestring_regex)$/i);
    my ($date1, $date2);
    if ($1 && $2) {
        ($date1, $date2) = parse_all_datestrings_to_date($1, $2);
    } else {
        my $date_object = DateTime->now;
        my ($currentDay, $currentMonth, $currentYear) = ($date_object->day(), $date_object->month(), $date_object->year());
        my $t = join " ", $currentDay, $months[$currentMonth - 1], $currentYear;
        ($date1, $date2) = parse_all_datestrings_to_date($1, $t);
    }

    return unless ($date1 && $date2);
    ($date1, $date2) = ($date2, $date1) if ( DateTime->compare($date1, $date2) == 1 );

    my $difference = $date1->delta_days($date2);
    my $daysBetween = abs($difference->in_units('days'));
    my $inclusive = '';
    if(/inclusive/) {
        $daysBetween += 1;
        $inclusive = ', inclusive';
    }
    my $startDate = date_output_string($date1);
    my $endDate   = date_output_string($date2);

    return "There are $daysBetween days between $startDate and $endDate$inclusive",
      structured_answer => {
        data => {
            title    => $daysBetween,
            subtitle => "Days between$inclusive $startDate - $endDate"
        },
        templates => {
            group => "text"
        }
      };
};

1;
