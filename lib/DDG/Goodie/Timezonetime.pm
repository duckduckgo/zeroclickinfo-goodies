package DDG::Goodie::Timezonetime;
# ABSTRACT: Gives the current time in a specified timezone

use DDG::Goodie;
use strict;
use warnings;

use DateTime;
use DateTime::TimeZone;

zci answer_type => 'timezonetime';
zci is_cached => 1;

triggers start => ("what time in", "what time is it in", "time in");
triggers startend => ("time", "now time", "time now");

# Mapping short timezone names to one used by DateTime:Timezone module
my $timezoneMapping = {
    "IST" => "Asia/Kolkata", 
    "EST" => "EST", 
    "UTC" => "UTC", 
    "GMT" => "GMT",
    "BST" => "Europe/London", 
    "PST" => "PST8PDT", 
    "CST" => "CST6CDT"
};
    
my $timezones = join('|', keys(%$timezoneMapping));

handle remainder => sub {
    my $query = $_;
    
    my $daylightStatus = "";
    
    my $timezone = uc($query);
    my $mappedTimezone = $timezoneMapping->{$timezone} // 0;
    return unless $mappedTimezone; 

    # Get time for desired timezone
    my $tz = DateTime::TimeZone->new( name => $mappedTimezone );
    my $dt = DateTime->now();
    my $offset = $tz->offset_for_datetime($dt);
    $dt->add(seconds => $offset);
    my $time = $dt->hms(':');

    # Check if timezone is in daylight saving or not    
    if ($tz->is_dst_for_datetime( $dt )) {
        $daylightStatus = "$timezone is in daylight saving";
    }
    else {
        $daylightStatus = "$timezone is not in daylight saving";
    }
    
    return "$time $timezone $daylightStatus",
        structured_answer => {

            data => {
                title       => "$time $timezone",
                subtitle    => "$daylightStatus",
            },
            templates => {
                group => 'text',
            }
        };
};

1;
