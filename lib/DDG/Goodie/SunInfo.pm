package DDG::Goodie::SunInfo;
# ABSTRACT: sunrise and sunset information for the client location

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';
with 'DDG::GoodieRole::ImageLoader';

use DateTime::Event::Sunrise;
use utf8;

zci answer_type => "sun_info";
zci is_cached   => 0;

triggers startend => 'sunrise', 'sunset', 'what time is sunset', 'what time is sunrise';

primary_example_queries 'sunrise',              'sunset';
secondary_example_queries 'sunrise for aug 30', 'sunset on 2015-01-01';
description 'Compute the sunrise and sunset for a given day';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/SunInfo.pm';
category 'calculations';
topics 'everyday';
attribution github => ['duckduckgo', 'DuckDuckGo'];

my $time_format      = '%l:%M %p';
my $datestring_regex = datestring_regex();

my $sunrise_svg = goodie_img_tag({
    filename => 'sunrise.svg',
    height   => 48,
    width    => 48,
});
my $sunset_svg = goodie_img_tag({
    filename => 'sunset.svg',
    height   => 48,
    width    => 48,
});

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
    $dt = parse_datestring_to_date($+{'when'}) if($+{'when'});
    
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

    return pretty_output($where, date_output_string($dt), $sunrise, $sunset);
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
    } elsif (my $country = $loc->country) {
        # Country and continent, then, I guess.
        # United States, NA
        @where_bits = ($loc->country, $loc->continent_code);
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

    my $html = "<div class='zci--suninfo'>";
    $html .= "<div class='suninfo--header text--secondary'><span class='ddgsi'>@</span>$where on $when</div>";
    $html .= "<div class='suninfo--row'>".
        "<span class='suninfo--risebox'>"
      . $sunrise_svg
      . "</span><span class='suninfo--timeboxes suninfo--border-right'><span class='text--primary suninfo--times'>$rise</span></span>";
    $html .=
        "<span class='suninfo--setbox'>"
      . $sunset_svg
      . "</span><span class='suninfo--timeboxes'><span class='text--primary suninfo--times'>$set</span></span>";
    $html .= "</div></div>";

    return ($text, html => $html);
}

1;
