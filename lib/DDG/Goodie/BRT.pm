package DDG::Goodie::BRT;
# ABSTRACT: Track a shipment from BRT (formerly Bartolini)

use DDG::Goodie;

zci answer_type => "brt";
zci is_cached   => 1;

name "BRT";
description "Track a shipment from BRT";
icon_url "https://afelicioni.github.io/assets/i/www.brt.it.ico";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/BRT.pm";
primary_example_queries "brt 114090393162";
secondary_example_queries "brtcode 1511409039316255850";
source "BRT";
category 'ids';
topics 'special_interest';
attribution web => ["https://afelicioni.github.io/", "Alessio Felicioni"],
            github => ["afelicioni", "Alessio Felicioni"],
            twitter => ["afelicioni_pro", "Alessio Felicioni"];

triggers start => "brt", "brtcode";

handle query_lc => sub {
    return unless /^(?:brt\s+(?:(?<c_brt>[0-9]{12})|(?<c_brtcode>[0-9]{19}))|brtcode\s+(?<c_brtcode>[0-9]{19}))$/;
    my $brt_num = $+{'c_brt'};
    my $brtcode_num = $+{'c_brtcode'};

    # BRT Shipment Tracking (using 12 digits basic code)
    if ( $brt_num ) {
        return $brt_num,
            heading => "BRT Tracking",
            html    => qq|Shipment tracking available at <a href="http://as777.brt.it/vas/sped_det_show.htm?referer=sped_numspe_par.htm&Nspediz=$brt_num&RicercaNumeroSpedizione=Ricerca">BRT</a>.|;
    }
    # BRT Shipment Tracking (using 19 digits "BRTcode")
    if ( $brtcode_num ) {
        return $brtcode_num,
            heading => "BRT Tracking",
            html    => qq|Shipment tracking available at <a href="http://as777.brt.it/vas/sped_det_show.htm?brtCode=$brtcode_num&urltype=a">BRT</a>.|;
    }
    return;
};

1;
