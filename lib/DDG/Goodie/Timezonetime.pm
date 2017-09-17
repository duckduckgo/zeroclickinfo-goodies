package DDG::Goodie::Timezonetime;
# ABSTRACT: Gives the current time in a specified timezone

use DDG::Goodie;
use strict;
use warnings;

use YAML::XS qw/LoadFile/;

use DateTime;
use DateTime::TimeZone;

zci answer_type => 'timezonetime';
zci is_cached => 1;

triggers start => ("what time in", "what time is it in", "time in");
triggers startend => ("time", "now time", "time now");

# Mapping short timezone names to one used by DateTime:Timezone module
my $timezoneMapping = LoadFile(share('abbreviations.yaml'));

# Add a field (offset_seconds) with offsets converted to seconds.
for my $abbreviation (keys %{$timezoneMapping}) {
    for my $timezone (@{$timezoneMapping->{$abbreviation}}) {
        my $seconds = DateTime::TimeZone->offset_as_seconds($timezone->{offset});
        $timezone->{offset_seconds} = $seconds;
    }
}

handle remainder => sub {
    my $query = $_;
    
    my $timezone = uc($query);
    my $mappedTimezones = $timezoneMapping->{$timezone} // 0;
    return unless $mappedTimezones; 

    # Get time for desired timezones
    my $dt = DateTime->now(time_zone => 'UTC');
    my @times = (); 
    for (@{$mappedTimezones}) {
        my $dt_clone = $dt->clone;
        $dt_clone->add(seconds => $_->{offset_seconds});
        push @times, { name => $_->{name}, 
                       time => $dt_clone->hms(':'),
                       offset => $_->{offset},
                       day => $dt_clone->day,
                       dayName => $dt_clone->day_name,
                       monthName => $dt_clone->month_name,
                       year => $dt_clone->year };
    }
    
    return "times in $timezone",
        structured_answer => {
            meta => {
                sourceName => 'timeanddate',
                sourceUrl => 'https://www.timeanddate.com/time/zones/'
            },
            data => {
                title => "Timezone $timezone",
                list => \@times
            },
            templates => {
                group => 'list',
                options => {
                    list_content => 'DDH.timezonetime.content'
                }
            }
        };
};

1;
