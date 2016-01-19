package DDG::Goodie::HKDK;
# ABSTRACT: Track a package through HKDK.

use strict;
use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "hkdk";

triggers query_nowhitespace_nodash => qr/([a-z]{2}\d{9}(?:hk|dk))/i;

handle query_nowhitespace_nodash => sub {
    my $package_number = $1;

    if ( $package_number =~ /hk$/i ) {
        return $package_number, heading => 'Hongkong Post Shipment Tracking', html => qq(Track this shipment at <a href="http://app3.hongkongpost.com/CGI/mt/genresult.jsp?tracknbr=$package_number">Hongkong Post</a>.);
    }
    elsif ( $package_number =~ /dk$/i ) {
        return $package_number, heading => 'Post Norden Shipment Tracking', html => qq(Track this shipment at <a href="http://www.postdanmark.dk/tracktrace/TrackTrace.do?i_stregkode=$package_number">Post Norden</a>.);
    }

    return;
};

1;
