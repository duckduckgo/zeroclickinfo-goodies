#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'usps';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::USPS )],
        'EA 000 000 000 US' => test_zci(
        	"EA000000000US",
        	heading => 'USPS Shipment Tracking',
        	html => qq(Track this shipment at <a href="https://tools.usps.com/go/TrackConfirmAction.action?tLabels=EA000000000US">USPS</a>.)
        ),
        'usps 7000 0000 0000 0000 0000' => test_zci(
        	"70000000000000000000",
        	heading => 'USPS Shipment Tracking',
        	html => qq(Track this shipment at <a href="https://tools.usps.com/go/TrackConfirmAction.action?tLabels=70000000000000000000">USPS</a>.)
        ),
);

done_testing;

