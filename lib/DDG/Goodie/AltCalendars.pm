package DDG::Goodie::AltCalendars;
# ABSTRACT: Convert non-Gregorian years to the Gregorian calendar

use strict;
use DDG::Goodie;
use JSON;

my $definitions_json = share('definitions.json')->slurp();
my $year_definitions = decode_json($definitions_json);

triggers any => keys $year_definitions;

zci answer_type => 'date_conversion';
zci is_cached => 1;

handle query_parts => sub {
    # Ignore single word queries
    return unless scalar(@_) > 1;

    if ($_ =~ /^(.*\b)([A-Za-z]+)\s+(\d*[1-9]\d*)(.*\b)$/i) {
        my $era_name = lc($2);
        my $era_year = $3;
        my $gregorian_year_started = $year_definitions->{$era_name}->{'gregorian_year_started'};
        my $wikipedia_link = $year_definitions->{$era_name}->{'wikipedia_link'};
        my $year = $gregorian_year_started + $era_year;
        
        $era_name = ucfirst($era_name);

        my $answer = "$era_name $era_year is equivalent to $year in the Gregorian Calendar";

        return $answer,
            structured_answer => {
                data => {
                    title => $year,
                    subtitle => "$era_name Year $era_year"
                },
                meta => {
                    sourceName => "Wikipedia",
                    sourceUrl => "$wikipedia_link"
                },
                templates => {
                    group => 'info',
                    options => {
                        moreAt => 1
                    }
                }
        };
    }

    return;
};

1;
