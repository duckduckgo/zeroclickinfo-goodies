package DDG::Goodie::Timediff;
# ABSTRACT: provides the duration between dates

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';
with 'DDG::GoodieRole::NumberStyler';

triggers any => qw(timediff);

zci is_cached   => 0;
zci answer_type => 'timediff';


my $datestring_regex = datestring_regex();

handle remainder => sub {
    my $query = $_;

    return unless $query =~ /^(?:between\s)?($datestring_regex)\s(?:and\s)?($datestring_regex)$/i;
    
    my @dates = parse_all_datestrings_to_date($1,$2);
    my $duration = abs $dates[0]->epoch - $dates[1]->epoch;
    
    return "$duration seconds",
        structured_answer => {
            data => {
                seconds => $duration,
                minutes => $duration/60,
                hours => $duration/3600,
                days => $duration/86400
            },
            templates => {
                group => 'text',
                options => {
                    content => 'DDH.timediff.content'
                }
            }
        };
};

1;
