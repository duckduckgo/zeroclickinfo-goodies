package DDG::Goodie::Timediff;
# ABSTRACT: provides the duration between dates

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';
with 'DDG::GoodieRole::NumberStyler';

my @units = qw(days hours minutes seconds);

triggers any => ["timediff", "duration", "time difference", map {"$_ between"} @units];

zci is_cached   => 0;
zci answer_type => 'timediff';

my $datestring_regex = datestring_regex();
my $style = number_style_for("1");

handle remainder => sub {
    my $query = $_;

    return unless $query =~ /^(?:between\s)?($datestring_regex)\s(?:and\s)?($datestring_regex)$/i;
    
    my @dates = parse_all_datestrings_to_date($1,$2);
    return unless((scalar @dates) == 2);
    my $duration = abs $dates[0]->epoch - $dates[1]->epoch;
    
    return "$duration seconds",
        structured_answer => {
            data => {
                title => "".date_output_string($dates[0], true)." - ".date_output_string($dates[1], true),
                record_data => {
                    seconds => $style->for_display($duration),
                    minutes => $style->for_display($duration/60),
                    hours   => $style->for_display($duration/3600),
                    days    => $style->for_display($duration/86400)
                },
                record_keys => \@units,
            },
            templates => {
                group => 'list',
                options => {
                    content => 'record',
                    moreAt => 0
                }
            }
        };
};

1;