package DDG::Goodie::SunInfo;
# ABSTRACT: sunrise and sunset information for the client location

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

use DateTime::Event::Sunrise;
use utf8;

zci answer_type => "sun_info";
zci is_cached   => 0;

triggers startend => 'sunrise', 'sunset', 'what time is sunset', 'what time is sunrise';

my $time_format      = '%l:%M %p';
my $date_parser      = date_parser();
my $datestring_regex = datestring_regex();

my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

my $lat_lon_regex = qr/[\+\-]?[0-9]+(?:
        (?:\.[0-9]+[°]?)
        |(?:°?
            (?:[0-9]{1,2}')?
            (?:[0-9]{1,2}(?:''|"))?
        )
    )?/x;

handle remainder => sub {
    my $remainder = shift // '';
    $remainder =~ s/\?//g;    # Strip question marks.
    return unless $remainder =~ qr/^
        (?:at\s
            (?<lat>$lat_lon_regex[NS])\s
            (?<lon>$lat_lon_regex[EW])\s?
        )?
        (?:on|for)?\s?
        (?<when>$datestring_regex)?
    $/xi;

    my ($lat, $lon, $tz) = ($loc->latitude, $loc->longitude, $loc->time_zone);
    my $where = where_string();
    return unless (($lat || $lon) && $tz && $where);    # We'll need a real location and time zone.
    my $dt = DateTime->now;;
    $dt = $date_parser->parse_datestring_to_date($+{'when'}) if($+{'when'});

    return unless $dt;                                  # Also going to need to know which day.
    $dt->set_time_zone($tz) unless ($+{'lat'} && $+{'lon'});

    $lon = parse_arc($+{'lon'}) if ($+{'lon'});
    $lat = parse_arc($+{'lat'}) if ($+{'lat'});

    $where = "Coordinates ${lat}°N ${lon}°E" if($+{'lat'} && $+{'lon'});

    my $sun_at_loc = DateTime::Event::Sunrise->new(
        longitude => $lon,
        latitude  => $lat,
        precise   => 1,                                 # Slower but more precise.
        silent    => 1,                                 # Don't fill up STDERR with noise, if we have trouble.
    );

    # We don't care for which one they asked, we compute both sunrise and sunset
    my $sunrise = $sun_at_loc->sunrise_datetime($dt)->strftime($time_format);
    my $sunset  = $sun_at_loc->sunset_datetime($dt)->strftime($time_format);

    return pretty_output($where, $date_parser->for_display($dt), $sunrise, $sunset);
};

sub where_string {
    my @where_bits;
    if (my $city = $loc->city) {
        # If we have the city we can abbrev the region or country, if avail.
        #  - Phoenixville, Pennsylvania
        @where_bits = ($city, $loc->region_name || $loc->country_code3);
    } elsif (my $region_name = $loc->region_name) {
        # No city, but a region name; abbreviate the country or continent
        # - Pennsylvania, USA
        @where_bits = ($region_name, $loc->country_code3 || $loc->continent_code);
    } elsif (my $country = $loc->country_name) {
        # Country and continent, then, I guess.
        # United States, NA
        @where_bits = ($loc->country_name, $loc->continent_code);
    }
    return join(', ', @where_bits);
}

sub parse_arc {
    my ($arc_string) = @_;
    return unless $arc_string =~ qr/
        (?<sign>[\+\-])?(?<deg>[0-9]+)(?:
            ((?<dec_deg>\.[0-9]+)[°]?)
            |(?:°?
                (?:(?<min>[0-9]{1,2})')?
                (?:(?<sec>[0-9]{1,2})(?:''|"))?
            )
        )?(?<dir>[NSEW])/x;
    my $decimal_degrees = $+{'deg'};
    $decimal_degrees += $+{'dec_deg'} if $+{'dec_deg'};
    $decimal_degrees += $+{'min'}/60 if $+{'min'};
    $decimal_degrees += $+{'sec'}/3600 if $+{'sec'};
    $decimal_degrees *= -1 if $+{'sign'} && $+{'sign'} eq '-' || $+{'dir'} =~ /[SW]/;
    return $decimal_degrees;
}

sub pretty_output {
    my ($where, $when, $rise, $set) = @_;

    $rise =~ s/^\s+//g;    # strftime puts a space in front for single-digits.
    $set =~ s/^\s+//g;

    my $text = "On $when, sunrise in $where is at $rise; sunset at $set.";

    return $text,
    structured_answer => {
        data => {
            where => $where,
            when_data => $when,
            sunrise_svg => "/share/goodie/sun_info/$goodieVersion/sunrise.svg",
            rise => $rise,
            sunset_svg => "/share/goodie/sun_info/$goodieVersion/sunset.svg",
            set_data => $set
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                title_content => 'DDH.sun_info.title',
                content => 'DDH.sun_info.content'
            }
        }
    };

}

1;
