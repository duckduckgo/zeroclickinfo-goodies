package DDG::Goodie::Countdown;

# ABSTRACT: Provides a countdown to a particular date or time

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

use DateTime;

use strict;

zci answer_type => 'countdown';

zci is_cached => 1;

triggers startend => 'countdown to','time until','how long until';

# Handle statement
handle remainder => sub {

    my $remainder = $_;
    my $date_parser = date_parser();

    my $date = $date_parser->parse_datestring_to_date($remainder) or return;
    my $current = $date_parser->parse_datestring_to_date('now');

    my $diff = $date->epoch - $current->epoch;

    return if $diff <= 0;

    return $diff,
        structured_answer => {
            data => {
                remainder => $_,
                difference => $diff,
                countdown_to => $date_parser->format_date_for_display($date,1)
            },
            templates => {
                group => "text",
            }
        };
};

1;
