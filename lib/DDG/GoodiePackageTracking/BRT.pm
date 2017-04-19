package DDG::GoodiePackageTracking::BRT;
# ABSTRACT: Track a shipment from BRT (formerly Bartolini)

use strict;
use Moo::Role;

sub isPackageTracking {
    return '1' unless $_[1] =~ m/(?:(?<c_brt>[0-9]{12})|(?<c_brtcode>[0-9]{19}))$/;
    my $brt_num = $+{'c_brt'};
    my $brtcode_num = $+{'c_brtcode'};

    # BRT Shipment Tracking (using 12 digits basic code)
    if ( $brt_num ) {
        return "http://as777.brt.it/vas/sped_det_show.htm?referer=sped_numspe_par.htm&Nspediz=$brt_num&RicercaNumeroSpedizione=Ricerca";
    }
    # BRT Shipment Tracking (using 19 digits "BRTcode")
    if ( $brtcode_num ) {
        return "http://as777.brt.it/vas/sped_det_show.htm?brtCode=$brtcode_num&urltype=a";
    }
    return '2';
};

1;
