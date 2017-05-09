package DDG::Goodie::DaysBetween;
# ABSTRACT: Return number of years/days/hours/minutes/seconds between two chosen dates.

use strict;
use DDG::Goodie;
use DateTime;
with 'DDG::GoodieRole::Dates';

triggers start => "dates calculator", "date calculator", "days between", "daysbetween", "days_between", "number of days between", "how many days between", "number of days from", "days from";

# 'Days since' will calculate days from the specified date to the present date, therefore answer cannot be cached
zci is_cached => 0;
zci answer_type => "days_between";

handle query_lc => sub {
    return "plain text response",
           structured_answer => {
               data => {
                 title => "Date Math",
                   },
               templates => {}
           };
};

1;
