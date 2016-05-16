package DDG::Goodie::DaysBetween;
# ABSTRACT: Return number of years/days/hours/minutes/seconds between two chosen dates.

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

triggers start => "dates calculator", "date calculator", "days between", "daysbetween", "days_between", "number of days between", "how many days between", "number of days from", "days from", "minutes between", "hours between", "years between";

triggers end => "in minutes", "in seconds", "in hours", "in years", "in days", "in minutes";

zci is_cached => 1;
zci answer_type => "days_between";

handle query_lc => sub {
    return "plain text response",
           structured_answer => {
               data => {
                 title => "Date Math",
                   },
               templates => {
                   group => "list",
                   options => {
                     subtitle_content => 'DDH.days_between.content',
                     content => "record",
                     rowHighlight => 'true',
                   }
               }
           };
};

1;
