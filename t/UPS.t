#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'ups';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::UPS )],
        '1Z0884XV0399906189' => test_zci(
        	"1Z0884XV0399906189",
        	heading => 'UPS Shipment Tracking',
        	html => qq(Track this shipment at <a href="http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displayed=1&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=1Z0884XV0399906189&track.x=0&track.y=0">UPS</a>.)
        ),
        'ups 1Z0884XV0399906189' => test_zci(
        	"1Z0884XV0399906189",
        	heading => 'UPS Shipment Tracking',
        	html => qq(Track this shipment at <a href="http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displayed=1&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=1Z0884XV0399906189&track.x=0&track.y=0">UPS</a>.)
        ),
        '1Z2807700371226497' => test_zci(
            '1Z2807700371226497',
            html => 'Track this shipment at <a href="http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displayed=1&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=1Z2807700371226497&track.x=0&track.y=0">UPS</a>.', heading => 'UPS Shipment Tracking'
        ),
        'ups 1Z2807700371226497' => test_zci(
            '1Z2807700371226497',
            html => 'Track this shipment at <a href="http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displayed=1&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=1Z2807700371226497&track.x=0&track.y=0">UPS</a>.', heading => 'UPS Shipment Tracking'
        ),
);

done_testing;

