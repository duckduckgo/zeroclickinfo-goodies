package DDG::Goodie::DaysBetween;
# ABSTRACT: Give the number of days between two given dates.

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

triggers start => "days between", "days", "daysbetween", "days_between", "number of days between", "how many days between", "number of days from", "days from";

zci is_cached => 1;
zci answer_type => "days_between";

my $datestring_regex = datestring_regex();

handle remainder => sub {
    return unless $_ =~ qr/^($datestring_regex) (?:(?:and|to) )?($datestring_regex)(?:[,]? inclusive)?$/i;

    my ($date1, $date2) = parse_all_datestrings_to_date($1, $2);
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

    return "There are $daysBetween days between $startDate and $endDate$inclusive.",
      structured_answer => {
        input     => [$startDate, $endDate,],
        operation => 'Days between' . $inclusive,
        result    => $daysBetween
      };
};

1;
