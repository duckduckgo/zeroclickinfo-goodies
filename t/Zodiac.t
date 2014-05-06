#!/usr/bin/env perl

use strict;
use warnings;
use Date::Manip;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'zodiac';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Zodiac
        )],

		#Test Aries
        'Zodiac 21st March 1967' 	=> test_zci('Star Sign : Aries'),
        'StarSign 30 Mar' 			=> test_zci('Star Sign : Aries'),
		'20 April star sign'		=> test_zci('Star Sign : Aries'),

		#Test Taurus
        'Zodiac 21st April 2014' 	=> test_zci('Star Sign : Taurus'),
        'StarSign 27 Apr' 			=> test_zci('Star Sign : Taurus'),
		'21 May star sign'			=> test_zci('Star Sign : Taurus'),

		#Test Gemini
        'Zodiac 22nd May 1500' 		=> test_zci('Star Sign : Gemini'),
        'StarSign 31 May' 			=> test_zci('Star Sign : Gemini'),
		'21 jun star sign'			=> test_zci('Star Sign : Gemini'),

		#Test Cancer
        'Zodiac 22nd June 1889' 	=> test_zci('Star Sign : Cancer'),
        'StarSign 30 June 2017'		=> test_zci('Star Sign : Cancer'),
		'22nd july star sign'		=> test_zci('Star Sign : Cancer'),

		#Test Leo
        'Zodiac 23 July 1654' 		=> test_zci('Star Sign : Leo'),
        'StarSign 24th July' 		=> test_zci('Star Sign : Leo'),
		'22 aug star sign'			=> test_zci('Star Sign : Leo'),

		#Test Virgo
        'Zodiac 23rd Aug 1700' 		=> test_zci('Star Sign : Virgo'),
        'StarSign 1 Sep' 			=> test_zci('Star Sign : Virgo'),
		'23rd Sep star sign'		=> test_zci('Star Sign : Virgo'),

		#Test Libra 
        'Zodiac 24 September 2001' 	=> test_zci('Star Sign : Libra'),
        'StarSign 7th October' 		=> test_zci('Star Sign : Libra'),
		'23 oct star sign'			=> test_zci('Star Sign : Libra'),

		#Test Scorpio
        'Zodiac 24 October 1213' 	=> test_zci('Star Sign : Scorpio'),
        'StarSign 9th November' 	=> test_zci('Star Sign : Scorpio'),
		'22 nov star sign'			=> test_zci('Star Sign : Scorpio'),

		#Test Sagittarius
        'Zodiac 23 Nov 1857' 		=> test_zci('Star Sign : Sagittarius'),
        'StarSign 6 Dec' 			=> test_zci('Star Sign : Sagittarius'),
		'21 Dec star sign'			=> test_zci('Star Sign : Sagittarius'),

		#Test Capricorn
        'Zodiac 22nd December' 		=> test_zci('Star Sign : Capricorn'),
        'StarSign 23 Dec 1378' 		=> test_zci('Star Sign : Capricorn'),
		'20 Jan star sign'			=> test_zci('Star Sign : Capricorn'),
        'starsign 31 Dec 2009' 		=> test_zci('Star Sign : Capricorn'),
        '1 Jan zodiac' 				=> test_zci('Star Sign : Capricorn'),

		#Test Aquarius
        'Zodiac 21st Jan' 			=> test_zci('Star Sign : Aquarius'),
        'StarSign 1st Feb' 			=> test_zci('Star Sign : Aquarius'),
		'19 Feb star sign'			=> test_zci('Star Sign : Aquarius'),

		#Test Pisces
        'Zodiac 20th Feb 1967' 		=> test_zci('Star Sign : Pisces'),
        'StarSign 1st Mar' 			=> test_zci('Star Sign : Pisces'),
		'20 Mar star sign'			=> test_zci('Star Sign : Pisces'),

		#Test Invalid Inputs
		'Zodiac 21.05.1965'			=> undef,
		'31st April 1876 zodiac'	=> undef,
		'31Feb'						=> undef				

);

done_testing;
