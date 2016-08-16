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

my $style = number_style_for("1");

handle remainder => sub {
    my $query = $_;

    my $date_parser = date_parser();
    my @dates = $date_parser->extract_dates_from_string($query) or return;
    return unless @dates == 2;

    my $duration = abs $dates[0]->epoch - $dates[1]->epoch;

    return "$duration seconds",
        structured_answer => {
            data => {
                title => $date_parser->format_date_for_display($dates[0], 1) .
                         ' - ' .
                         $date_parser->format_date_for_display($dates[1], 1),
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
