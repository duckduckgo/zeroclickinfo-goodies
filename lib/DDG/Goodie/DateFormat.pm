package DDG::Goodie::DateFormat;

# ABSTRACT: Get locale and alternative formats for a date format.

use DDG::Goodie;
use strict;

use DateTime::Locale;
use Try::Tiny;

zci answer_type => 'date_format';

zci is_cached => 1;

triggers any => 'cldr', 'locale', 'format';

handle query => sub {
    my $query = shift;

    return unless $query =~ /^(?<format>.+?) format for (?<locale>.+?)$/i;
    my $format = $+{'format'};
    my $locale = $+{'locale'};

    my $date_loc = try { DateTime::Locale->load($locale) } or return;

    my $res_format = $date_loc->format_for($format) or return;

    return "$res_format",
        structured_answer => {

            data => {
                title => $res_format,
                subtitle => "$locale format for $format",
            },

            templates => {
                group => "text",
            }
        };
};

1;
