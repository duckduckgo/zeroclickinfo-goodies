package DDG::Goodie::DHL;
# ABSTRACT: track a package through DHL.

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "dhl";

primary_example_queries 'DHL 123456789';
secondary_example_queries 'tracking 1234567891';
description 'Track a package from DHL';
name 'DHL';
icon_url "/i/www.dhl.com.ico";
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DHL.pm';
category 'ids';
topics 'special_interest';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];

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
    # dhl = 3 ==> german DHL number

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
    
    if (length($package_number) eq 12) {
        $is_dhl = 3; 
          
    }

    if ($is_dhl eq 3) {
        return $package_number, heading => "DHL Shipment Tracking (Germany)", html => "Track this shipment at <a href='http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=de&idc=$package_number'>DHL Germany</a>.";
        
        # I just added DHL Germany by checking for 12-char-IDs. The checksum algo for those is not known, if you know a better way to detect DHL Germany tracking IDs, please improve. 
    
    }
    
    elsif ($is_dhl) {
        return $package_number, heading => "DHL Shipment Tracking", html => "Track this shipment at <a href='http://www.dhl-usa.com/content/us/en/express/tracking.shtml?brand=DHL&AWB=$package_number'>DHL</a>.";
    }

    return;
};

1;
