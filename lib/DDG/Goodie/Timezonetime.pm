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

handle remainder => sub {
    my $query = $_;
    
    my $timezone = uc($query);
    my $mappedTimezones = $timezoneMapping->{$timezone} // 0;
    return unless $mappedTimezones; 

    # Get time for desired timezones
    my $dt = DateTime->now(time_zone => 'UTC');
    my @times = map {
        my $offset = DateTime::TimeZone->offset_as_seconds($_->{offset});
        my $dt_clone = $dt->clone;
        $dt_clone->add(seconds => $offset);
        { name => $_->{name},
          time => $dt_clone->hms(':'), 
          offset => $_->{offset} };
    } @{$mappedTimezones};
    
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
