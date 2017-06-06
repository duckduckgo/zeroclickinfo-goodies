package DDG::Goodie::DHL;
# ABSTRACT: track a package through DHL.

use strict;
use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "dhl";

# Regex for usps.
my $dhl_qr = qr/dhl/io;
my $tracking_qr = qr/package|track(?:ing|)|num(?:ber|)|\#/i;

triggers query_nowhitespace_nodash => qr/
                                        ^$dhl_qr.*?([\d]{9,})$|
                                        ^([\d]{9,}).*?$dhl_qr$|
                                        ^(?:$tracking_qr|$dhl_qr|)*([\d]{10})(?:$tracking_qr|$dhl_qr|)*$
                                        /xo;

handle query_nowhitespace_nodash => sub {
    # If a Canada Post package number (2 for exclusively).
    my $is_dhl = 0;

    # Tracking number.
    my $package_number = '';

    # Exclsuive trigger.
    if ($1 || $2) {
        $package_number = $1 || $2;
        $is_dhl         = 2;
    }
    elsif ($3) {
        $package_number = $3;

        my $checksum   = 0;
        my @chars      = split( //, $package_number );
        my $length     = scalar(@chars);
        my $char_count = 0;
        my $odd_sum    = 0;
        my $even_sum   = 0;
        foreach my $char (@chars) {
            $char_count++;

            if ($char_count % 2 == 0) {
                $even_sum += $char;
            }
            else {
                $odd_sum += $char;
            }
        }
        $even_sum *= 1;
        $odd_sum  *= 1;

        #       $checksum = ($odd_sum+$even_sum) % 7;
        #       $checksum = 10-$checksum if $checksum;

        $checksum = join( '', @chars[ 0 .. $length - 2 ] ) % 7;

        if ($checksum eq $chars[-1]) {
            $is_dhl = 1;
        }
    }

    if ($is_dhl) {
	my $string_answer = qq(Track this shipment at http://www.dhl-usa.com/content/us/en/express/tracking.shtml?brand=DHL&AWB=$package_number);
        return $string_answer,
                structured_answer => {
                data => {
                        package_number => $package_number
                },
                templates => {
                        group => 'text',
                        options => {
                                content => 'DDH.dhl.content'
                        }
                }
        };

    }

    return;
};

1;
