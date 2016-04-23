package DDG::Goodie::DayOfWeek;
# ABSTRACT: Calculates day of the week a given date falls on

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


my @trigger_words = (
             'day of week',               'day of the week',
        'what day of week',          'what day of the week',
    'what was day of week',      'what was day of the week',
                             'what was the day of the week',
            'what day will',
            'what day was',
    'will be what day',
        'was what day',
);
triggers startend => @trigger_words;

# Handle statement
handle remainder => sub {
    my $remainder = $_;
    my $date_parser = date_parser();
    my ($input_date, @rest) = $date_parser->extract_dates_from_string($remainder);
    return if @rest;

    return unless $input_date;

    my $out_date     = $date_parser->format_date_for_display($input_date);
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
