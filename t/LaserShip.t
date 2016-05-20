#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'lasership';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::LaserShip )],
        'LL12345678' => test_zci(
        	"LL12345678",
        	heading => 'Lasership Shipment Tracking',
        	html => qq(Track this shipment at <a href="http://lasership.com/track/LL12345678">Lasership</a>.)
        ),
        'LL 12345678' => test_zci(
        	"LL12345678",
        	heading => 'Lasership Shipment Tracking',
        	html => qq(Track this shipment at <a href="http://lasership.com/track/LL12345678">Lasership</a>.)
        ),
        '1LS12345678999999999' => undef
);

done_testing;
