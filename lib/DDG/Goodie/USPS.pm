package DDG::Goodie::USPS;
# ABSTRACT: Track a package through the US postal service.

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "usps";

primary_example_queries 'EA 000 000 000 US';
secondary_example_queries 'usps 7000 0000 0000 0000 0000';
description 'Track a USPS package';
name 'USPS';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/USPS.pm';
category 'ids';
topics 'special_interest';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'duckduckgo', 'DuckDuckGo'],
            twitter => ['duckduckgo', 'DuckDuckGo'];

# Regex for usps.
my $usps_qr = qr/u(?:nited|)s(?:states|)(?:p(?:ostal|)s(?:ervice|)|)/io;
my $tracking_qr = qr/package|track(?:ing|)|num(?:ber|)|\#/i;

triggers query_nowhitespace_nodash => qr/^
                                         $usps_qr.*?([\d]{9,})\s*$|
                                         ^([\d]{9,}).*?$usps_qr$|
                                         ^$usps_qr?([a-z]{2}\d{9}us)$usps_qr?$|
                                         ^(?:$tracking_qr|$usps_qr|)*([\d]{20,30})(?:$tracking_qr|$usps_qr|)*$
                                        /xio;

handle query_nowhitespace_nodash => sub {
    # If a USPS package number (2 for exclusively).
    my $is_usps = 0;

    # Tracking number.
    my $package_number = '';

    # Exclsuive trigger.
    if ($1 || $2 || $3) {
        $package_number = $1 || $2 || $3;
        $is_usps        = 2;

    # No exclusive trigger, do checksum.
    # Since the package numbers are just numbers,
    # we are more strict in regex (e.g. than UPS).
    # 2010.08.30 expanding to 30 bc of 420010279101805213907525025140
    }
    elsif ($4) {
        $package_number = $4;

      PACKAGE: for ( my $i = 0 ; $i < 2 ; $i++ ) {

            my $tmp_package_number = $package_number;
            ($tmp_package_number) = $package_number =~ /^\d{8}(.*)/ if $i == 1;

            my $checksum   = 0;
            my @chars      = split( //, $tmp_package_number );
            my $length     = scalar(@chars);
            my $char_count = 0;
            my $odd_sum    = 0;
            my $even_sum   = 0;
            foreach my $char ( reverse @chars ) {
                $char_count++;

                # Skip check digit.
                next if $char_count == 1;

                if ( $char_count % 2 == 0 ) {
                    $even_sum += $char;
                }
                else {
                    $odd_sum += $char;
                }

            }
            $even_sum *= 3;
            $checksum = ( $odd_sum + $even_sum ) % 10;
            $checksum = 10 - $checksum if $checksum;

            if ($checksum eq $chars[-1]) {
                $is_usps = 1;
            }

            last PACKAGE if $is_usps || length( $package_number < 30 );
        }

    }

    if ($is_usps) {
        return $package_number, heading => "USPS Shipment Tracking", html => qq(Track this shipment at <a href="https://tools.usps.com/go/TrackConfirmAction.action?tLabels=$package_number">USPS</a>.);
    }

    return;
};

1;
