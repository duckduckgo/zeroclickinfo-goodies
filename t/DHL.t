#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
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
        'DHL 123456789012' => test_zci(
            '123456789012',
            heading => 'DHL Shipment Tracking (Germany)',
            html => "Track this shipment at <a href='http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=de&idc=123456789012'>DHL Germany</a>.",
        ),
        
        
        
        
        'DHL JJD12345678901' => test_zci(   #no tracking DHL Germany
            'JJD12345678901',
            heading => 'DHL Shipment Tracking (Germany)',
            html => "Track this shipment at <a href='http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=de&idc=JJD12345678901'>DHL Germany</a>.",
        ),        
        
        'DHL JJD12345678901234567890' => test_zci(  #tracking DHL Germany
            'JJD12345678901234567890',
            heading => 'DHL Shipment Tracking (Germany)',
            html => "Track this shipment at <a href='http://nolp.dhl.de/nextt-online-public/set_identcodes.do?lang=de&idc=JJD12345678901234567890'>DHL Germany</a>.",
        ),        
);

done_testing;
