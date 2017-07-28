package DDG::Goodie::Timezonetime;
# ABSTRACT: Write an abstract here

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if
# you are new to instant answer development

use DDG::Goodie;
use strict;
use warnings;

use DateTime;
use DateTime::TimeZone;

zci answer_type => 'timezonetime';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers at the start of the query
my @triggerStart = ("time in", "time now");
# Triggers at the end of the query
my @triggerEnd   = ("now time");
# Final trigger list
my @triggersFinal = (@triggerStart, @triggerEnd);

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers any => @triggersFinal;

# Mapping short timezone names to one used by DateTime:Timezone module
my $timezoneMapping = {"IST" => "Asia/Kolkata", "EST" => "EST", "UTC" => "UTC", "GMT" => "GMT",
                       "PST" => "PST8PDT", "BST" => "Europe/London", "CST" => "CST6CDT"
                      };

# Handle statement
handle query_lc => sub {

    my $query_lc = $_;
    
    my $timezones = join('|', keys(%$timezoneMapping));
    my $daylightStatus = "";
    
    # Parsing timezone out of query string
    $query_lc =~ s/.*\b($timezones)\b.*/$1/ig;
    my $timezone = uc($query_lc);
    
    # If timezone is not in hash then return null
    unless (exists($timezoneMapping->{$timezone})) {
	return;
    }

    # Getting corresponding timezone value from hash
    my $mappedTimezone = $timezoneMapping->{$timezone};

    # Get time for desired timezone
    my $tz = DateTime::TimeZone->new( name => $mappedTimezone );
    my $dt = DateTime->now();
    my $offset = $tz->offset_for_datetime($dt);
    $dt->add(seconds => $offset);
    my $time = $dt->hms(':');

    # Check if timezone is in daylight saving or not    
    if ($tz->is_dst_for_datetime( $dt )) {
	$daylightStatus = "$timezone is in daylight saving";
    }  else {
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
                # options => {
                #
                # }
            }
        };
};

1;
