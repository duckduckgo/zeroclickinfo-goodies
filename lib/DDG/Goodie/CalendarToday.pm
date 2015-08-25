package DDG::Goodie::CalendarToday;
# ABSTRACT: Print calendar of current / given month and highlight (to)day

use strict;
use DDG::Goodie;
use DateTime;
use Try::Tiny;
use Text::Trim;

with 'DDG::GoodieRole::Dates';

zci answer_type => 'calendar';
zci is_cached   => 0;

primary_example_queries "calendar";
secondary_example_queries "calendar november",
                          "calendar next november",
                          "calendar november 2015",
                          "cal 29 nov 1980",
                          "cal 29.11.1980",
                          "cal 1980-11-29";

description "Print calendar of given year and highlight today";
name "Calendar Today";
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CalendarToday.pm';
category "dates";
topics "everyday";
attribution email   => ['webmaster@quovadit.org', 'j@rubinovitz.com'];
triggers startend => 'calendar', 'cal';

# define variables
my @weekDays = ("S", "M", "T", "W", "T", "F", "S");

my $filler_words_regex         = qr/(?:\b(?:on|of|for|the|a)\b)/;
my $datestring_regex           = datestring_regex();
my $formatted_datestring_regex = formatted_datestring_regex();
my $relative_dates_regex       = relative_dates_regex();

handle remainder => sub {
    my $query       = $_;
    my $date_object = DateTime->now;
    my ($currentDay, $currentMonth, $currentYear) = ($date_object->day(), $date_object->month(), $date_object->year());
    my $highlightDay = 0;                  # Initialized, but won't match, by default.
    $query =~ s/$filler_words_regex//g;    # Remove filler words.
    $query =~ s/\s{2,}/ /g;                # Tighten up any extra spaces we may have left.
    $query =~ s/'s//g;                     # Remove 's for possessives.
    $query = trim $query;                  # Trim outside spaces.

    if ($query) {
        my ($date_string) = $query =~ qr#^($datestring_regex)$#i;    # Extract any datestring from the query.
        $date_object = parse_datestring_to_date($date_string);
        # check if our date regex figured out the date
        if ($date_object){
            my ($currentDay, $currentMonth, $currentYear) = ($date_object->day(), $date_object->month(), $date_object->year());
        } else {
            # check if 4 digit year is being queried e.g. cal 1999
            if ($query =~ qr/^\d{4}$/){
                $date_object = DateTime->now->set_year($query);
            }
        }
        return unless $date_object;

    }

    my $the_year  = $date_object->year();
    my $the_month = $date_object->month();
    my $plaintext = "calendar today";
       return $plaintext,
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => {
                month => $the_month,
                day => $currentDay,
                year => $the_year
            },
            templates => {
               group => 'base',
               detail => 0,
                options => {
                    content => 'DDH.calendar_today.content',
                }
            }
     };
};

1;
