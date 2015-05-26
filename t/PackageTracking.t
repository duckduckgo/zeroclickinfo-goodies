#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'package_tracking';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::PackageTracking )],
        'CU123456789DK' => test_zci(
        	"CU123456789DK",
        	heading => 'Tracking Package',
        	html => qq(Track this shipment at <a href="http://www.postdanmark.dk/tracktrace/TrackTrace.do?i_stregkode=CU123456789DK">Post Norden</a>.)
        ),
        'EE123456789HK' => test_zci(
        	"EE123456789HK",
        	heading => 'Tracking Package',
        	html => qq(Track this shipment at <a href="http://app3.hongkongpost.com/CGI/mt/genresult.jsp?tracknbr=EE123456789HK">Hongkong Post</a>.)
        ),
        'YF123456789RU' => test_zci(
        	"YF123456789RU",
        	heading => 'Tracking Package',
        	html => qq(Track this shipment at <a href="http://www.russianpost.ru/tracking20/?YF123456789RU">Russian Post</a>.)
        ),
);

done_testing;

