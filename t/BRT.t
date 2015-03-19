#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "brt";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::BRT )],
    "brt 123456789012" => test_zci(
        "123456789012",
        heading => 'BRT Tracking',
        html    => 'Shipment tracking available at <a href="http://as777.brt.it/vas/sped_det_show.htm?referer=sped_numspe_par.htm&Nspediz=123456789012&RicercaNumeroSpedizione=Ricerca">BRT</a>.'
    ),
    "brtcode 1234567890123456789" => test_zci(
        "1234567890123456789",
        heading => 'BRT Tracking',
        html    => 'Shipment tracking available at <a href="http://as777.brt.it/vas/sped_det_show.htm?brtCode=1234567890123456789&urltype=a">BRT</a>.'
    ),
    "brt 1234567890123456789" => test_zci(
        "1234567890123456789",
        heading => 'BRT Tracking',
        html    => 'Shipment tracking available at <a href="http://as777.brt.it/vas/sped_det_show.htm?brtCode=1234567890123456789&urltype=a">BRT</a>.'
    ),
    "brt 1234" => undef,
    "brtcode 1234" => undef,
    "brt 1234" => undef
);

done_testing;
