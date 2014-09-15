#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'zodiac';

ddg_goodie_test([qw(
          DDG::Goodie::Zodiac
          )
    ],

    #Test Aries
    'Zodiac 21st March 1967' => test_zci('Star Sign for 21 Mar 1967: Aries'),
    'StarSign 30 Mar'        => test_zci('Star Sign for 30 Mar 2014: Aries'),
    '20 April star sign'     => test_zci('Star Sign for 20 Apr 2014: Aries'),

    #Test Taurus
    'Zodiac 21st April 2014' => test_zci('Star Sign for 21 Apr 2014: Taurus'),
    'StarSign 27 Apr'        => test_zci('Star Sign for 27 Apr 2014: Taurus'),

    #Test Gemini
    '21 May star sign'     => test_zci('Star Sign for 21 May 2014: Gemini'),
    'Zodiac 22nd May 1500' => test_zci('Star Sign for 22 May 1500: Gemini'),
    'Zodiac 21.05.1965'    => test_zci('Star Sign for 21 May 1965: Gemini'),
    'StarSign 31 May'      => test_zci('Star Sign for 31 May 2014: Gemini'),
    '21 jun star sign'     => test_zci('Star Sign for 21 Jun 2014: Gemini'),

    #Test Cancer
    'Zodiac 22nd June 1889' => test_zci('Star Sign for 22 Jun 1889: Cancer'),
    'StarSign 30 June 2017' => test_zci('Star Sign for 30 Jun 2017: Cancer'),
    '22nd july star sign'   => test_zci('Star Sign for 22 Jul 2014: Cancer'),

    #Test Leo
    'Zodiac 23 July 1654'  => test_zci('Star Sign for 23 Jul 1654: Leo'),
    'StarSign 24th July'   => test_zci('Star Sign for 24 Jul 2014: Leo'),
    '22 aug star sign'     => test_zci('Star Sign for 22 Aug 2014: Leo'),
    'Zodiac 23rd Aug 1700' => test_zci('Star Sign for 23 Aug 1700: Leo'),

    #Test Virgo
    'StarSign 1 Sep' => test_zci('Star Sign for 01 Sep 2014: Virgo'),

    #Test Libra
    '23rd Sep star sign'       => test_zci('Star Sign for 23 Sep 2014: Libra'),
    'Zodiac 24 September 2001' => test_zci('Star Sign for 24 Sep 2001: Libra'),
    'StarSign 7th October'     => test_zci('Star Sign for 07 Oct 2014: Libra'),

    #Test Scorpius
    '23 oct star sign'       => test_zci('Star Sign for 23 Oct 2014: Scorpius'),
    'Zodiac 24 October 1213' => test_zci('Star Sign for 24 Oct 1213: Scorpius'),
    'StarSign 9th November'  => test_zci('Star Sign for 09 Nov 2014: Scorpius'),

    #Test Sagittarius
    '22 nov star sign'   => test_zci('Star Sign for 22 Nov 2014: Sagittarius'),
    'Zodiac 23 Nov 1857' => test_zci('Star Sign for 23 Nov 1857: Sagittarius'),
    'StarSign 6 Dec'     => test_zci('Star Sign for 06 Dec 2014: Sagittarius'),
    '21 Dec star sign'   => test_zci('Star Sign for 21 Dec 2014: Sagittarius'),

    #Test Capricornus
    'Zodiac 22nd December' => test_zci('Star Sign for 22 Dec 2014: Capricornus'),
    'StarSign 23 Dec 1378' => test_zci('Star Sign for 23 Dec 1378: Capricornus'),
    'starsign 31 Dec 2009' => test_zci('Star Sign for 31 Dec 2009: Capricornus'),
    '31.12.2100 zodiac'    => test_zci('Star Sign for 31 Dec 2100: Capricornus'),
    '1 Jan zodiac'         => test_zci('Star Sign for 01 Jan 2014: Capricornus'),

    #Test Aquarius
    '20 Jan star sign' => test_zci('Star Sign for 20 Jan 2014: Aquarius'),
    'Zodiac 21st Jan'  => test_zci('Star Sign for 21 Jan 2014: Aquarius'),
    'StarSign 1st Feb' => test_zci('Star Sign for 01 Feb 2014: Aquarius'),

    #Test Pisces
    '19 Feb star sign'     => test_zci('Star Sign for 19 Feb 2014: Pisces'),
    'Zodiac 20th Feb 1967' => test_zci('Star Sign for 20 Feb 1967: Pisces'),
    'StarSign 1st Mar'     => test_zci('Star Sign for 01 Mar 2014: Pisces'),
    '20 Mar star sign'     => test_zci('Star Sign for 20 Mar 2014: Pisces'),

    #Test Invalid Inputs
    '31st April 1876 zodiac' => undef,
    'Zodiac 31Feb'           => undef,
    'Zodiac 5thMay1200'      => undef,

);

done_testing;
