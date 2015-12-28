package DDG::Goodie::DayOfWeek;
# ABSTRACT: Calculates what day of the week a given day falls on

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';


zci answer_type => 'day_of_week';
zci is_cached   => 1;

primary_example_queries 'day of week for June 22 1907';
secondary_example_queries 'day of week for 1/1/2012', 'what day will 15 Jan 2025 be', 'what day was 2015-01-02', '01/13/2015 was what day';
description 'calculate day of the week for a date';
name 'DayOfWeek';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DayOfWeek.pm';
category 'time_sensitive';
topics 'everyday';
attribution github => ['http://github.com/cngarrison', 'cngarrison'];


triggers startend => 'day of week', 'day of the week', 'what day will', 'what day was', 'was what day';

my $datestring_regex = datestring_regex();

# Handle statement
handle remainder => sub {
    my $remainder = $_;
    return unless $remainder && 
                  $remainder =~ qr/(?<date>$datestring_regex)/x;
    
    my $input_date   = parse_datestring_to_date($+{date});
    return unless $input_date;
    
    my $out_date     = date_output_string($input_date);
    my $day_of_week  = $input_date->day_name;

    my $text = "Day of the Week: $day_of_week";

    return $text,
        structured_answer => {
            id   => 'day_of_week',
            name => 'Answer',
            data => {
              title => $day_of_week,
              subtitle => "Day of the week for: $out_date",
            },
            templates => {
                group => "text",
                moreAt => 0
            }
        };
};

1;
