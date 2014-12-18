#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'dhl';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::DHL )],
        'dhl 123456789' => test_zci(
        	"123456789",
        	heading => 'DHL Shipment Tracking',
        	html => qq(Track this shipment at <a href='http://www.dhl-usa.com/content/us/en/express/tracking.shtml?brand=DHL&AWB=123456789'>DHL</a>.)
        ),
        'tracking 1234567891' => test_zci(
        	"1234567891",
        	heading => 'DHL Shipment Tracking',
        	html => qq(Track this shipment at <a href='http://www.dhl-usa.com/content/us/en/express/tracking.shtml?brand=DHL&AWB=1234567891'>DHL</a>.)
        ),
        'DHL 123456789' => test_zci(
            '123456789',
            heading => 'DHL Shipment Tracking',
            html => "Track this shipment at <a href='http://www.dhl-usa.com/content/us/en/express/tracking.shtml?brand=DHL&AWB=123456789'>DHL</a>.",
        ),
);

done_testing;

