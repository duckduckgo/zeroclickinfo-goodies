package DDG::Goodie::AltCalendars;
# ABSTRACT: Convert non-Gregorian years to the Gregorian calendar

use strict;

use DateTime;
use DDG::Goodie;
use JSON;

my $base_wiki_link = "https://en.wikipedia.org/wiki/";

my $definitions_json = share('definitions.json')->slurp();
my $year_definitions = decode_json($definitions_json);

my %year_map_with_aliases = map { 
  my $name = $_; 
  map { $_ => $name } ($name, @{$year_definitions->{$name}->{'aliases'} // []}) 
} (keys %{$year_definitions});

triggers any => keys %year_map_with_aliases;

zci answer_type => 'date_conversion';
zci is_cached => 1;

handle query_parts => sub {
    # Ignore single word queries
    return unless scalar(@_) > 1;

    if ($_ =~ /^([A-Za-z]+)\s+(\d*[1-9]\d*)$/) {
        my $era_name = lc($1);
        my $era_year = $2;
        
        my $parent_era = $year_map_with_aliases{$era_name};
        
        return unless $parent_era;
        
        my $era_hash = $year_definitions->{$parent_era};
        
        my $gregorian_year_started = $era_hash->{'gregorian_year_started'};
        my $wiki_page = $era_hash->{'wikipedia_page'};
        my $year = $gregorian_year_started + $era_year;
        my $era = DateTime->now->set_year($year)->era;
        
        $era_name = ucfirst($era_name);
        $year = abs($year);

        my $answer = "$era_name $era_year is equivalent to $year $era in the Gregorian Calendar";

        return $answer,
            structured_answer => {
                data => {
                    title => "$year $era",
                    subtitle => "$era_name Year $era_year"
                },
                meta => {
                    sourceName => "Wikipedia",
                    sourceUrl => "$base_wiki_link$wiki_page"
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
