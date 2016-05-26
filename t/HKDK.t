#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'hkdk';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::HKDK )],
        'CU123456789DK' => test_zci(
        	"CU123456789DK",
        	heading => 'Post Norden Shipment Tracking',
        	html => qq(Track this shipment at <a href="http://www.postdanmark.dk/tracktrace/TrackTrace.do?i_stregkode=CU123456789DK">Post Norden</a>.)
        ),
        'EE123456789HK' => test_zci(
        	"EE123456789HK",
        	heading => 'Hongkong Post Shipment Tracking',
        	html => qq(Track this shipment at <a href="http://app3.hongkongpost.com/CGI/mt/genresult.jsp?tracknbr=EE123456789HK">Hongkong Post</a>.)
        ),
);

done_testing;
