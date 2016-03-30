package DDG::Goodie::DaysBetween;
# ABSTRACT: Give the number of days between two given dates.

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

triggers start => "days between", "days", "daysbetween", "days_between", "number of days between", "how many days between", "number of days from", "days from";

zci is_cached => 1;
zci answer_type => "days_between";

my $datestring_regex = datestring_regex();
my $date_parser = date_parser();

handle remainder => sub {
    my $query = shift;

    my ($date1, $date2, @rest) = $date_parser->extract_dates_from_string($query);
    return unless ($date1 && $date2 && !@rest);
    my $remainder = $_;
    $remainder =~ s/(and|to)//;
    $remainder =~ s/\s+//g;

    ($date1, $date2) = ($date2, $date1) if ( DateTime->compare($date1, $date2) == 1 );

    my $difference = $date1->delta_days($date2);
    my $daysBetween = abs($difference->in_units('days'));
    my $inclusive = '';
    if($remainder =~ s/\s*inclusive\s*//) {
        $daysBetween += 1;
        $inclusive = ', inclusive';
    }
    return if $remainder ne '';
    my $startDate = $date_parser->for_display($date1);
    my $endDate   = $date_parser->for_display($date2);

    return "There are $daysBetween days between $startDate and $endDate$inclusive.",
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
