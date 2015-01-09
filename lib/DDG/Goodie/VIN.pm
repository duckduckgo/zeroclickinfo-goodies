package DDG::Goodie::VIN;
# ABSTRACT: extract information about vehicle identification numbers

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "vin";

primary_example_queries '1g8gg35m1g7123101';
secondary_example_queries 'vin 1g8gg35m1g7123101', '1g8gg35m1g7123101 vehicle identification number', '1g8gg35m1g7123101 tracking';

description 'Automobile VIN lookup';
name 'VIN';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/VIN.pm';
category 'ids';
topics 'special_interest';
attribution web => ['https://www.duckduckgo.com', 'DuckDuckGo'],
            github => ['duckduckgo', 'DuckDuckGo'],
            twitter => ['duckduckgo', 'DuckDuckGo'];

triggers query_lc => qr/([\d+a-z]{17})|
                        (^\d+$)
                        /x;

# Regex for VIN.
my $vin_qr = qr/v(?:ehicle|)i(?:dentification|)n(?:umber|)/oi;
my $tracking_qr = qr/package|track(?:ing|)|num(?:ber|)|\#/i;

# Checksum for VIN.
my %vin_checksum = (
    'A' => 1,
    'B' => 2,
    'C' => 3,
    'D' => 4,
    'E' => 5,
    'F' => 6,
    'G' => 7,
    'H' => 8,
    'I' => 'X',
    'J' => 1,
    'K' => 2,
    'L' => 3,
    'M' => 4,
    'N' => 5,
    'O' => 'X',
    'P' => 7,
    'Q' => 'X',
    'R' => 9,
    'S' => 2,
    'T' => 3,
    'U' => 4,
    'V' => 5,
    'W' => 6,
    'X' => 7,
    'Y' => 8,
    'Z' => 9,
);

my %vin_checksum_weight = (
    '1' => 8,
    '2' => 7,
    '3' => 6,
    '4' => 5,
    '5' => 4,
    '6' => 3,
    '7' => 2,
    '8' => 10,
    '9' => 0,
    '10' => 9,
    '11' => 8,
    '12' => 7,
    '13' => 6,
    '14' => 5,
    '15' => 4,
    '16' => 3,
    '17' => 2,
);

# VIN numbers.
# 2008.07.29 force some letters because
# "Alvin and the Chipmunks songs" passes checksum.
# See http://en.wikipedia.org/wiki/Vehicle_identification_number#Check_digit_calculation
# 2012.03.22 remove ^ and $ from 2nd regex term to also allow
# 'vin <vin>, etc' -- a regular vin just triggers w.js?
handle query_nowhitespace_nodash => sub {
    my ($query) = @_;

    # If a VIN number (2 for exclusively).
    my $is_vin = 0;

    # VIN number.
    my $vin_number = '';

    # Exclsuive trigger.
    if ($query =~ /^$vin_qr.*?([A-Z\d]{17,})$/i || $query =~ /^([A-Z\d]{17,}).*?$vin_qr$/i) {
        $vin_number = uc $1;
        $is_vin     = 2;

    # No exclusive trigger, do checksum.
    # Since the vin numbers are just numbers,
    # we are more strict in regex (e.g. than UPS).
    } elsif($query =~ /^(?:$tracking_qr|$vin_qr|)*([A-Z\d]{17})(?:$tracking_qr|$vin_qr|)*$/io || $query =~ /^(?:$tracking_qr|$vin_qr|)*([A-Z\d]{17})(?:$tracking_qr|$vin_qr|)*$/io) {
        $vin_number = uc $1;

        my $checksum   = 0;
        my @chars      = split( //, $vin_number );
        my $length     = scalar(@chars);
        my $char_count = 0;
        my $sum        = 0;

        my $letter_count = 0;

        foreach my $char (@chars) {
            $char_count++;
            $letter_count++ if $char =~ /[A-Z]/;

            # Grab number.
            my $char_num = $char;
            $char_num = $vin_checksum{$char} if exists $vin_checksum{$char};

            # Make sure number.
            if ( $char_num eq 'X' ) {
                $checksum = -1;
                last;
            }

            # Use weight.
            $sum += $char_num * $vin_checksum_weight{$char_count};
        }
        $checksum = $sum % 11;
        $checksum = 'X' if $checksum == 10;

        if ($checksum eq $chars[8] && $letter_count > 3) {
            $is_vin = 1;
        }
    }


    if ($is_vin) {
        return $vin_number, heading => "Vehicle Identification Number", html => qq(Check the automobile's VIN at <a href='http://www.decodethis.com/VIN-Decoded/vin/$vin_number'>Decode This</a>.);
    }

    return;
};

1;
