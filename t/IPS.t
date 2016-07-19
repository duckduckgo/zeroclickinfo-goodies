#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'ips';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::IPS )],
        'EM999999999IN' => test_zci(
        	"EM999999999IN",
        	heading => 'IPS Shipment Tracking',
        	html => qq(Track this shipment at <a href="http://ipsweb.ptcmysore.gov.in/ipswebtracking/IPSWeb_item_events.asp?itemid=EM999999999IN&Submit=Submit">IPS</a>.)
        ),
        'em123456789hr' => test_zci(
        	"em123456789hr",
        	heading => 'IPS Shipment Tracking',
        	html => qq(Track this shipment at <a href="http://ips.posta.hr/IPSWeb_item_events.asp?itemid=em123456789hr&Submit=Submit">IPS</a>.)
        ),
        'EM 999 999 999 IN' => test_zci(
                "EM999999999IN",
                heading => 'IPS Shipment Tracking',
                html => qq(Track this shipment at <a href="http://ipsweb.ptcmysore.gov.in/ipswebtracking/IPSWeb_item_events.asp?itemid=EM999999999IN&Submit=Submit">IPS</a>.)
        )
);

done_testing;
