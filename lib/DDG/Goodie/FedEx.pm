package DDG::Goodie::FedEx;

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "fedex";

# Regex for fedex.
my $fedex_qr = qr/fed(?:eral|)ex(?:press|)/io;
my $tracking_qr = qr/package|track(?:ing|)|num(?:ber|)|\#/i;

triggers query_nowhitespace_nodash => qr/
                                        ^$fedex_qr.*?([\d]{9,})$|
                                        ^([\d]{9,}).*?$fedex_qr$|
                                        ^(?:$tracking_qr|$fedex_qr|)*?(\d*?)([\d]{15,20})(?:$tracking_qr|$fedex_qr|)*$|
                                        ^(?:$tracking_qr|$fedex_qr|)*?(\d*?)([\d]{12})(?:$tracking_qr|$fedex_qr|)*$
                                        /xio;

# Fedex package tracking.
# See http://answers.google.com/answers/main?cmd=threadview&id=207899
# See http://images.fedex.com/us/solutions/ppe/FedEx_Ground_Label_Layout_Specification.pdf
handle query_nowhitespace_nodash => sub {
    # If a Fedex package number (2 for exclusively).
    my $is_fedex = 0;

    # Tracking number.
    my $package_number = '';

    # Exclsuive trigger.
    if ($1 || $2) {
        $package_number = $1 || $2;
        $is_fedex       = 2;

        # No exclusive trigger, do checksum.
        # Since the package numbers are just numbers,
        # we are more strict in regex (e.g. than UPS).
        # 15 has to be before 12 or it will block.
    }
    elsif (($3 && $4) || ($5 && $6)) {
        my $package_beg = $3 || $5;
        $package_number = $4 || $6;

        my $checksum   = -1;
        my @chars      = split( //, $package_number );
        my $length     = scalar(@chars);
        my $char_count = 0;
        my $sum        = 0;

        # Ground.
        if ( $length == 15 ) {

            my $odd_sum  = 0;
            my $even_sum = 0;
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
            if ( ( $odd_sum + $even_sum ) > 0 ) {
                $checksum = ( $odd_sum + $even_sum ) % 10;
                $checksum = 10 - $checksum if $checksum;
            }
        }
        else {
            foreach my $char (@chars) {

                if ( $char_count % 3 == 0 ) {
                    $sum += $char * 3;
                }
                elsif ( $char_count % 3 == 1 ) {
                    $sum += $char * 1;
                }
                else {
                    $sum += $char * 7;
                }

                $char_count++;
                last if $char_count == 11;
            }
            $checksum = ( $sum % 11 ) % 10 if $sum;
        }

        if (($length == 15 && $checksum eq $chars[-1]) || ($length != 15 && $checksum eq $chars[11])) {
            $is_fedex = 1;
            $package_number = qq($package_beg$package_number) if $package_beg;
        }
    }

    if ($is_fedex) {
        return heading => 'FedEx Shipment Tracking', html => qq(Track this shipment at <a href="http://fedex.com/Tracking?tracknumbers=$package_number&action=track">FedEx</a>.);
    }

    return;
};

1;