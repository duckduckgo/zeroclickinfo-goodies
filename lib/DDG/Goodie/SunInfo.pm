package DDG::Goodie::SunInfo;
# ABSTRACT: sunrise and sunset information for the client location

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

use DateTime::Event::Sunrise;

zci answer_type => "sun_info";
zci is_cached   => 0;

triggers start => 'sunrise', 'sunset', 'what time is sunset', 'what time is sunrise';

primary_example_queries 'sunrise',              'sunset';
secondary_example_queries 'sunrise for aug 30', 'sunset on 2015-01-01';
description 'Compute the sunrise and sunset for a given day';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/SunInfo.pm';
category 'calculations';
topics 'everyday';
attribution github => ['https://github.com/duckduckgo', 'duckduckgo'];

my $time_format = '%l:%M%P';
my $datestring_regex = datestring_regex();

handle remainder => sub {

    my $remainder = shift // '';
    $remainder =~ s/\?//g;    # Strip question marks.
    my ($lat, $lon, $tz) = ($loc->latitude, $loc->longitude, $loc->time_zone);
    my $where = where_string();
    return unless (($lat || $lon) && $tz && $where);    # We'll need a real location and time zone.
    my $dt;
    if (!$remainder) {
        $dt = DateTime->now;
    } elsif ($remainder =~ /^(?:on|for)\s+(?<when>$datestring_regex)$/) {
        $dt = parse_datestring_to_date($+{'when'});
    }
    return unless $dt;                                  # Also going to need to know which day.
    $dt->set_time_zone($tz);

    my $sun_at_loc = DateTime::Event::Sunrise->new(
        longitude => $lon,
        latitude  => $lat,
        precise   => 1,                                 # Slower but more precise.
        silent    => 1,                                 # Don't fill up STDERR with noise, if we have trouble.
    );

    # We don't care for which one they asked, we compute both sunrise and sunset
    my $sunrise = $sun_at_loc->sunrise_datetime($dt)->strftime($time_format);
    my $sunset  = $sun_at_loc->sunset_datetime($dt)->strftime($time_format);

    return pretty_prose($where, date_output_string($dt), $sunrise, $sunset);
};

sub where_string {
    my @where_bits;
    if (my $city = $loc->city) {
        # If we have the city we can abbrev the region or country, if avail.
        #  - Phoenixville, PA
        @where_bits = ($city, $loc->region || $loc->country_code3);
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

sub pretty_prose {
    my ($where, $when, $rise, $set) = @_;

    $rise =~ s/^\s+//g;    # strftime puts a space in front for single-digits.
    $set =~ s/^\s+//g;     # strftime puts a space in front for single-digits.

    my $html_pl = "<div class='zci--suninfo text--secondary'>";    # Prelude
    my $html_po = "<span class='text--primary'>";                  # Primary open
    my $html_pc = "</span>";                                       # Primary close
    my $html_el = "</div>";                                        # Epilogue

    # Now let us horribly abuse sprintf() for fun and profit.
    my $prose = "%sOn %s$when%s, sunrise in %s$where%s is at %s$rise%s; sunset at %s$set%s.%s";

    # Also map abuse.
    my @text_args = map { ''; } (0 .. 9);
    my @html_args = ($html_pl, (map { ($html_po, $html_pc); } (0 .. 3)), $html_el);

    return (sprintf($prose, @text_args), html => sprintf($prose, @html_args));
}

1;
