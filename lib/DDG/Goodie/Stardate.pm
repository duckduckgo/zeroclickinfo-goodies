package DDG::Goodie::Stardate;
# ABSTRACT: Returns stardate (see Star Trek)

use DDG::Goodie;
use strict;
with 'DDG::GoodieRole::Dates';

zci answer_type => 'stardate';
zci is_cached => 0;

triggers start => 'stardate';

handle remainder => sub {
    my $query = $_;
    my $date_parser = date_parser();
    my $parsed_date = $date_parser->parse_datestring_to_date($query || "today");
    return unless $parsed_date;

    my $seconds = $parsed_date->strftime("%s");

    my $answer = $parsed_date->strftime("%Y%m%d.").int($seconds % 86400 / 86400 * 100000);

    return $answer,
        structured_answer => {
            data => {
                title => $answer,
                subtitle => "Stardate for " . $date_parser->format_date_for_display($parsed_date, 1),
            },
            templates => {
                group => "text",
            }
        };
};

1;
