package DDG::Goodie::DaysBetween;
# ABSTRACT: Give the number of days between two given dates.

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

triggers start => "days between", "days", "daysbetween", "days_between";

zci is_cached => 1;
zci answer_type => "days_between";

primary_example_queries 'days between 01/31/2000 01/31/2001';
secondary_example_queries 'days between 01/31/2000 01/31/2001 inclusive';
description 'calculate the number of days between two dates';
name 'DaysBetween';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DaysBetween.pm';
category 'calculations';
topics 'everyday';
attribution github => ['http://github.com/JetFault', 'JetFault'];

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
        operation => 'days between' . $inclusive,
        result    => $daysBetween
      };
};

1;
