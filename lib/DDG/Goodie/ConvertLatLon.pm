package DDG::Goodie::ConvertLatLon;
# ABSTRACT: Convert between latitudes and longitudes expressed in degrees of arc and decimal

use DDG::Goodie;
use utf8;
use Geo::Coordinates::DecimalDegrees;
use Math::SigFigs qw(:all);
use Math::Round;

zci is_cached => 1;

name 'Convert Latitude and Longitude';
description 'Convert between latitudes and longitudes expressed in degrees of arc and decimal';
primary_example_queries '71º 10\' 3" in decimal';
secondary_example_queries '71 degrees 10 minutes 3 seconds east in decimal', '- 16º 30\' 0" - 68º 9\' 0" as decimal';
category 'transformations';
topics 'geography', 'math', 'science';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ConvertLatLon.pm';
attribution github => ['http://github.com/wilkox', 'wilkox'];

triggers any => "convert", "dms", "decimal", "latitude", "longitude", "minutes", "seconds";

#Load the CSS
my $css = share("style.css")->slurp;

#Regexes for latitude/longitude, in either dms or decimal format
# http://msdn.microsoft.com/en-us/library/aa578799.aspx has a good
# overview of the most common representations of latitude/longitude

#Potential Unicode and other representations of "degrees"
my $degQR = qr/
    [º°⁰]|
    ((arc[-]?)?deg(ree)?s?)
    /ix;

#Potential Unicode and other representations of "minutes"
my $minQR = qr/
    ['`ʹ′‵‘’‛]|
    ((arc[-]?)?min(ute)?s?)
    /ix;

#Potential Unicode and other representations of "seconds"
my $secQR = qr/
    ["″″‶“”〝〞‟]|
    $minQR{2}|
    (arc[-]?)?sec(ond)?s?
    /ix;

#Match a decimal or integer number
my $numQR = qr/[\d\.]+/;

#Match a minus sign or attempt at minus sign or word processor
# interpretation of minus sign
my $minusQR = qr/
    [-−﹣－‒–—‐]|
    (minus)|
    (negative)
    /ix;

#Match a latitude/longitude representation
my $latLonQR = qr/
    (?<minus>$minusQR)?
    (?<degrees>$numQR)$degQR
    ((?<minutes>$numQR)$minQR
    ((?<seconds>$numQR)$secQR)?)?
    (?<cardinal>[NSEW]|(north)|(south)|(east)|(west))?
    /ix;

my %cardinalSign = (
    N => 1,
    S => -1,
    E => 1,
    W => -1,
);

my %cardinalName = (
    n => 'N',
    north => 'N',
    s => 'S',
    south => 'S',
    e => 'E',
    east => 'E',
    w => 'W',
    west => 'W'
);

handle query_nowhitespace => sub {

    return unless /$latLonQR/;

    #Loop over all provided latitudes/longitudes
    # Not going to try and enforce strict latitude/longitude
    # pairing — if the user wants to pass in a long list
    # of latitudes or a single longitude, no problem as long
    # as they're all in the same format
    my @queries;
    my @results;
    my $toFormat;
    while (/$latLonQR/g) {

        my $minus = $+{minus};
        my $degrees = $+{degrees};
        my $minutes = $+{minutes};
        my $seconds = $+{seconds};
        my $cardinal = $+{cardinal};

        #Validation: must have minutes if has seconds
        return unless (($minutes && $seconds) || ! $seconds);

        #Validation: can't supply both minus sign and cardinal direction
        return if $minus && $cardinal;

        #Convert cardinal to standardised name if provided
        $cardinal = $cardinalName{lc($cardinal)} if $cardinal;

        #Set the sign
        my $sign;
        if ($cardinal) {
            $sign = $cardinalSign{$cardinal};
        } else {
            $sign = $minus ? -1 : 1;
        }

        #Determine type of conversion (dms -> decimal or decimal -> dms)
        # and perform as appropriate

        #If the degrees are expressed in decimal...
        if ($degrees =~ /\./) {

            #If this isn't the first conversion, make sure the 
            # user hasn't passed a mix of decimal and DMS
            return if $toFormat && ! $toFormat eq 'DMS';
            $toFormat = 'DMS';

            #Validation: must not have provided minutes and seconds
            return if $minutes || $seconds;

            #Validation: if only degrees were provided, make sure
            # the user isn't looking for a temperature or trigonometric conversion
            my $rejectQR = qr/temperature|farenheit|celsius|radians|kelvin|centigrade|\b$degQR\s?[FCK]/i;
            return if $_ =~ /$rejectQR/i;

            #Validation: can't exceed 90 degrees (if latitude) or 180 degrees
            # (if longitude or unknown)
            if ($cardinal && $cardinal =~ /[NS]/) {
                return if abs($degrees) > 90;
            } else {
                return if abs($degrees) > 180;
            }

            #Convert
            (my $dmsDegrees, my $dmsMinutes, my $dmsSeconds, my $dmsSign) = decimal2dms($degrees * $sign);

            #Annoyingly, Geo::Coordinates::DecimalDegrees will sign the degrees as
            # well as providing a sign
            $dmsDegrees = abs($dmsDegrees);

            #If seconds is fractional, take the mantissa
            $dmsSeconds = round($dmsSeconds);

            #Format nicely
            my $formattedDMS = format_dms($dmsDegrees, $dmsMinutes, $dmsSeconds, $dmsSign, $cardinal);
            my $formattedQuery = format_decimal(($degrees * $sign), $cardinal);

            push(@queries, $formattedQuery);
            push(@results, $formattedDMS);

        #Otherwise, we assume type is DMS (even if no
        # minutes/seconds given)
        } else {

            #If this isn't the first conversion, make sure the 
            # user hasn't passed a mix of decimal and DMS
            return if $toFormat && ! $toFormat eq 'decimal';
            $toFormat = 'decimal';

            #Validation: must have given at least minutes
            return unless $minutes;

            #Validation: can't have decimal minutes if there are seconds
            return if $minutes =~ /\./ && $seconds;

            #Validation: minutes and seconds can't exceed 60
            return if $minutes >= 60;
            return if $seconds && $seconds >= 60;

            #Apply the sign
            $degrees = $sign * $degrees;

            #Convert
            # Note that unlike decimal2dms, dms2decimal requires a signed degrees
            # and returns a signed degrees (not a separate sign variable)
            my $decDegrees = $seconds ? dms2decimal($degrees, $minutes, $seconds) : dm2decimal($degrees, $minutes);

            #Round to 8 significant figures
            $decDegrees = FormatSigFigs($decDegrees, 8);
            $decDegrees =~ s/\.$//g;

            #Validation: can't exceed 90 degrees (if latitude) or 180 degrees
            # (if longitude or unknown)
            if ($cardinal && $cardinal =~ /[NS]/) {
                return if abs($decDegrees) > 90;
            } else {
                return if abs($decDegrees) > 180;
            }

            #Format nicely
            my $formattedDec = format_decimal($decDegrees, $cardinal);
            my $formattedQuery = format_dms($degrees, $minutes, $seconds, $sign, $cardinal);

            push(@queries, $formattedQuery);
            push(@results, $formattedDec);

        }
    }

    my $answer = join(' ' , @results);
    my $html = wrap_html(\@queries, \@results, $toFormat);

    return $answer, html => $html;
};

#Format a degrees-minutes-seconds expression
sub format_dms {

    (my $dmsDegrees, my $dmsMinutes, my $dmsSeconds, my $dmsSign, my $cardinal) = @_;

    my $formatted = abs($dmsDegrees) . '°';
    $formatted .= ' ' . $dmsMinutes . '′' if $dmsMinutes;
    $formatted .= ' ' . $dmsSeconds . '″' if $dmsSeconds;

    #If a cardinal direction was supplied, use the cardinal
    if ($cardinal) {
        $formatted .= ' ' . uc($cardinal);

    #Otherwise, add a minus sign if negative
    } elsif ($dmsSign == -1) {
        $formatted = '−' . $formatted;
    }

    return $formatted;

}

#Format a decimal expression
sub format_decimal {

    (my $decDegrees, my $cardinal) = @_;

    my $formatted = abs($decDegrees) . '°';

    #If a cardinal direction was supplied, use the cardinal
    if ($cardinal) {
        $formatted .= ' ' . uc($cardinal);
    } elsif ($decDegrees / abs($decDegrees) == -1) {
        $formatted = '−' . $formatted;
    }

    return $formatted;

}

#CSS and HTML wrapper functions, copied from the
# Conversions Goodie to use the latest and greatest technology
# as implemented in PR #511
sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>$html";
}

sub wrap_secondary {
    my $secondary = shift;
    return "<span class='text--secondary'>" . $secondary . "</span>";
}

sub wrap_html {

    my @queries = @{$_[0]};
    my @results = @{$_[1]};
    my $toFormat = $_[2];

    my $queries = join wrap_secondary(', '), html_enc(@queries);
    my $results = join wrap_secondary(', '), html_enc(@results);

    my $html = "<div class='zci--conversions text--primary'>" . $queries . wrap_secondary(' in ' . $toFormat . ': ') . $results . "</div>";
    return append_css($html);
}

1;
