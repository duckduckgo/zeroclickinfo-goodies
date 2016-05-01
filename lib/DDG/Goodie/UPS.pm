package DDG::Goodie::UPS;
# ABSTRACT: Track a package through United Parcel Service.

use strict;
use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "ups";

# Regex for ups.
my $ups_qr = qr/ups/i;

triggers query_nowhitespace_nodash => qr/
                                        ^$ups_qr.*?(1Z[0-9A-Z]{16})$|
                                        ^(1Z[0-9A-Z]{16}).*$ups_qr$|
                                        (1Z[0-9A-Z]{16})
                                        /xi;

# See http://answers.google.com/answers/main?cmd=threadview&id=207899.
# fixme: 1Z9999W99999999999 from http://lifehacker.com/124236/google-numbers doesn't work.

handle query_nowhitespace_nodash => sub {
    # If a UPS package number (2 for exclusively).
    my $is_ups = 0;

    # Tracking number.
    my $package_number = '';

    # Checksum
    my %ups_checksum = (
        'A' => 2,
        'B' => 3,
        'C' => 4,
        'D' => 5,
        'E' => 6,
        'F' => 7,
        'G' => 8,
        'H' => 9,
        'I' => 0,
        'J' => 1,
        'K' => 2,
        'L' => 3,
        'M' => 4,
        'N' => 5,
        'O' => 6,
        'P' => 7,
        'Q' => 8,
        'R' => 9,
        'S' => 0,
        'T' => 1,
        'U' => 2,
        'V' => 3,
        'W' => 4,
        'X' => 5,
        'Y' => 6,
        'Z' => 7,
    );

    if($1 || $2) {
        $package_number = $1 || $2;
        $is_ups         = 2;
    } elsif($3) {
        $package_number = uc $3;

        my $checksum = 0;
        my @chars = split(//, $package_number);

        # Skip 1Z.
        @chars = @chars[ 2 .. scalar(@chars) - 1 ];

        my $length     = scalar(@chars);
        my $char_count = 0;
        my $odd_sum    = 0;
        my $even_sum   = 0;
        foreach my $char (@chars) {
            $char_count++;

            my $tmp_num = $char;
            if ( exists $ups_checksum{$char} ) {
                $tmp_num = $ups_checksum{$char};
            }

            if ( $char_count % 2 == 0 ) {
                $even_sum += $tmp_num;
            }
            else {
                $odd_sum += $tmp_num;
            }
        }
        $even_sum *= 2;
        $checksum = ( $odd_sum + $even_sum ) % 10;

        if ($checksum eq $chars[-1]) {
            $is_ups = 2;
        }
    }
    if($is_ups == 2 ) {
        return $package_number, heading => 'UPS Shipment Tracking', html => qq(Track this shipment at <a href="http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displayed=1&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=$package_number&track.x=0&track.y=0">UPS</a>.);
    }
    return;
};

1;
