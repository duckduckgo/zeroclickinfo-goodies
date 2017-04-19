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
                                      ^$dhl_qr([J][J][D][\d]{11,20})$|
                                      ^$dhl_qr([\d]{9,})$|
                                      ^([\d]{9,}).*?$dhl_qr$|
                                      ^$tracking_qr([\d]{10,})*$
                                      /xo;
                                      


handle query_nowhitespace_nodash => sub {

    my $is_dhl = 0;
    # dhl = 3 ==> german DHL number

    # Tracking number.
    my $package_number = '';
    my $track = 1; 

    if ($1) {
        $is_dhl = 3; 
        $package_number = $1;
        #if (length($1) eq 23) { 
        #    $track = 0; 
        #}
        
        #Tracking numbers with "JJD" and 20 chars are mostly packages without tracking. Not 100% sure, so I commented that line out. 
        
        if (length($1) eq 14) {
            $track = 1; 
        }
    
    }


     # Exclsuive trigger.
    if ($2 || $3) {
        $package_number = $2 || $3;
        $is_dhl = 2;
        
        if (length($package_number) eq 12) {
            $is_dhl = 3; 
            $track = 1; 
        }
        
        if (length($package_number) eq 20) {
        
            if (substr($package_number, 0, 4) eq "0034") {
                $is_dhl = 3; 
                $track = 1; 
            }
        
        
        }
    }
    
    
    elsif ($4) {
        
        $package_number = $4;

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
        
        if (length($package_number) eq 12) {
            $is_dhl = 3; 
            $track = 1; 
        }
        
    }
    

    if ($is_dhl eq 3) {
    
        if ($track eq 1) { 
            return $package_number, heading => "DHL Shipment Tracking (Germany)", html => "Track this shipment at <a href='http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=de&idc=$package_number'>DHL Germany</a>.";
        
        }
        
        elsif ($track eq 0) {
            return $package_number, heading => "DHL Shipment Tracking (Germany)", html => "No tracking available for DHL package $package_number. "
        
        }
         
         
    }
    
    elsif ($is_dhl) {
    
        
            return $package_number, heading => "DHL Shipment Tracking", html => "Track this shipment at <a href='http://www.dhl-usa.com/content/us/en/express/tracking.shtml?brand=DHL&AWB=$package_number'>DHL</a>.";
        
   
    
        
    }

    return;
};

1;
