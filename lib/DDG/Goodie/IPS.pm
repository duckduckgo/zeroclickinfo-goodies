package DDG::Goodie::IPS;
# ABSTRACT: track a package through IPS.

use strict;
use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "ips";

triggers query_nowhitespace_nodash => qr/(E[MA]\d{9})(IN|HR|)/xi;

handle query_nowhitespace_nodash => sub {
    my $package_number = $1 . $2;
    my $country = lc $2 || '';

    my $tmp_link = '';

    if ( $country eq 'in' ) {
        $tmp_link = "http://ipsweb.ptcmysore.gov.in/ipswebtracking/IPSWeb_item_events.asp?itemid=$package_number&Submit=Submit";
    }
    elsif ( $country eq 'hr' ) {
        $tmp_link = "http://ips.posta.hr/IPSWeb_item_events.asp?itemid=$package_number&Submit=Submit";
    }
    else {
        $tmp_link = "http://mailtracking.gov.bm/IPSWeb_item_events.asp?itemid=$package_number&Submit=Submit+Query";
    }
    if ($tmp_link) {
        return $package_number, heading => "IPS Shipment Tracking", html => qq(Track this shipment at <a href="$tmp_link">IPS</a>.);
    }

    return;
};

1;
