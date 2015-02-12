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
    'Zodiac 21st March 1967' => test_zci(
        'Zodiac for 21 Mar 1967: Aries',
        structured_answer => {
            input     => ['21 Mar 1967'],
            operation => 'Zodiac',
            result    => 'Aries'
        }
    ),

    'StarSign 30 Mar'        => test_zci(
	'Zodiac for 30 Mar 2015: Aries',
        structured_answer => {
            input     => ['30 Mar 2015'],
            operation => 'Zodiac',
            result    => 'Aries'
        }
    ),

    '20 April star sign'     => test_zci(
	'Zodiac for 20 Apr 2015: Aries',
        structured_answer => {
            input     => ['20 Apr 2015'],
            operation => 'Zodiac',
            result    => 'Aries'
        }
    ),

    #Test Taurus
    'Zodiac 21st April 2014' => test_zci(
	'Zodiac for 21 Apr 2014: Taurus',
        structured_answer => {
            input     => ['21 Apr 2014'],
            operation => 'Zodiac',
            result    => 'Taurus'
        }
    ),
    'StarSign 27 Apr'        => test_zci(
	'Zodiac for 27 Apr 2015: Taurus',
        structured_answer => {
            input     => ['27 Apr 2015'],
            operation => 'Zodiac',
            result    => 'Taurus'
        }
    ),

    #Test Gemini
    '21 May star sign'     => test_zci(
	'Zodiac for 21 May 2015: Gemini',
        structured_answer => {
            input     => ['21 May 2015'],
            operation => 'Zodiac',
            result    => 'Gemini'
        }
    ),

    'Zodiac 22nd May 1500' => test_zci(
	'Zodiac for 22 May 1500: Gemini',
        structured_answer => {
            input     => ['22 May 1500'],
            operation => 'Zodiac',
            result    => 'Gemini'
        }
    ),

    'Zodiac 21.05.1965'    => test_zci(
	'Zodiac for 21 May 1965: Gemini',
        structured_answer => {
            input     => ['21 May 1965'],
            operation => 'Zodiac',
            result    => 'Gemini'
        }
    ),

    'StarSign 31 May'      => test_zci(
	'Zodiac for 31 May 2015: Gemini',
        structured_answer => {
            input     => ['31 May 2015'],
            operation => 'Zodiac',
            result    => 'Gemini'
        }
    ),

    '21 jun star sign'     => test_zci(
	'Zodiac for 21 Jun 2015: Gemini',
        structured_answer => {
            input     => ['21 Jun 2015'],
            operation => 'Zodiac',
            result    => 'Gemini'
        }
    ),

    #Test Cancer
    'Zodiac 22nd June 1889' => test_zci(
	'Zodiac for 22 Jun 1889: Cancer',
        structured_answer => {
            input     => ['22 Jun 1889'],
            operation => 'Zodiac',
            result    => 'Cancer'
        }
    ),

    'StarSign 30 June 2017' => test_zci(
	'Zodiac for 30 Jun 2017: Cancer',
        structured_answer => {
            input     => ['30 Jun 2017'],
            operation => 'Zodiac',
            result    => 'Cancer'
        }
    ),

    '22nd july star sign'   => test_zci(
	'Zodiac for 22 Jul 2015: Cancer',
        structured_answer => {
            input     => ['22 Jul 2015'],
            operation => 'Zodiac',
            result    => 'Cancer'
        }
    ),

    #Test Leo
    'Zodiac 23 July 1654'  => test_zci(
	'Zodiac for 23 Jul 1654: Leo',
        structured_answer => {
            input     => ['23 Jul 1654'],
            operation => 'Zodiac',
            result    => 'Leo'
        }
    ),

    'StarSign 24th July'   => test_zci(
	'Zodiac for 24 Jul 2015: Leo',
        structured_answer => {
            input     => ['24 Jul 2015'],
            operation => 'Zodiac',
            result    => 'Leo'
        }
    ),

    '22 aug star sign'     => test_zci(
	'Zodiac for 22 Aug 2015: Leo',
        structured_answer => {
            input     => ['22 Aug 2015'],
            operation => 'Zodiac',
            result    => 'Leo'
        }
    ),

    'Zodiac 23rd Aug 1700' => test_zci(
	'Zodiac for 23 Aug 1700: Leo',
        structured_answer => {
            input     => ['23 Aug 1700'],
            operation => 'Zodiac',
            result    => 'Leo'
        }
    ),

    #Test Virgo
    'StarSign 1 Sep' => test_zci(
	'Zodiac for 01 Sep 2015: Virgo',
        structured_answer => {
            input     => ['01 Sep 2015'],
            operation => 'Zodiac',
            result    => 'Virgo'
        }
    ),

    #Test Libra
    '23rd Sep star sign'       => test_zci(
	'Zodiac for 23 Sep 2015: Libra',
        structured_answer => {
            input     => ['23 Sep 2015'],
            operation => 'Zodiac',
            result    => 'Libra'
        }
    ),

    'Zodiac 24 September 2001' => test_zci(
	'Zodiac for 24 Sep 2001: Libra',
        structured_answer => {
            input     => ['24 Sep 2001'],
            operation => 'Zodiac',
            result    => 'Libra'
        }
    ),

    'StarSign 7th October'     => test_zci(
	'Zodiac for 07 Oct 2015: Libra',
        structured_answer => {
            input     => ['07 Oct 2015'],
            operation => 'Zodiac',
            result    => 'Libra'
        }
    ),

    #Test Scorpius
    '23 oct star sign'       => test_zci(
	'Zodiac for 23 Oct 2015: Scorpius',
        structured_answer => {
            input     => ['23 Oct 2015'],
            operation => 'Zodiac',
            result    => 'Scorpius'
        }
    ),

    'Zodiac 24 October 1213' => test_zci(
	'Zodiac for 24 Oct 1213: Scorpius',
        structured_answer => {
            input     => ['24 Oct 1213'],
            operation => 'Zodiac',
            result    => 'Scorpius'
        } 
    ),

    'StarSign 9th November'  => test_zci(
	'Zodiac for 09 Nov 2015: Scorpius',
        structured_answer => {
            input     => ['09 Nov 2015'],
            operation => 'Zodiac',
            result    => 'Scorpius'
        }
    ),

    #Test Sagittarius
    '22 nov star sign'   => test_zci(
	'Zodiac for 22 Nov 2015: Sagittarius',
        structured_answer => {
            input     => ['22 Nov 2015'],
            operation => 'Zodiac',
            result    => 'Sagittarius'
        }
    ),

    'Zodiac 23 Nov 1857' => test_zci(
	'Zodiac for 23 Nov 1857: Sagittarius',
        structured_answer => {
            input     => ['23 Nov 1857'],
            operation => 'Zodiac',
            result    => 'Sagittarius'
        }
    ),

    'StarSign 6 Dec'     => test_zci(
	'Zodiac for 06 Dec 2015: Sagittarius',
        structured_answer => {
            input     => ['06 Dec 2015'],
            operation => 'Zodiac',
            result    => 'Sagittarius'
        }
     ),

    '21 Dec star sign'   => test_zci(
	'Zodiac for 21 Dec 2015: Sagittarius',
        structured_answer => {
            input     => ['21 Dec 2015'],
            operation => 'Zodiac',
            result    => 'Sagittarius'
        }
     ),

    #Test Capricornus
    'Zodiac 22nd December' => test_zci(
	'Zodiac for 22 Dec 2015: Capricornus',
        structured_answer => {
            input     => ['22 Dec 2015'],
            operation => 'Zodiac',
            result    => 'Capricornus'
        }
    ),

    'StarSign 23 Dec 1378' => test_zci(
	'Zodiac for 23 Dec 1378: Capricornus',
        structured_answer => {
            input     => ['23 Dec 1378'],
            operation => 'Zodiac',
            result    => 'Capricornus'
        }
    ),

    'starsign 31 Dec 2009' => test_zci(
	'Zodiac for 31 Dec 2009: Capricornus',
        structured_answer => {
            input     => ['31 Dec 2009'],
            operation => 'Zodiac',
            result    => 'Capricornus'
        }
    ),

    '31.12.2100 zodiac'    => test_zci(
	'Zodiac for 31 Dec 2100: Capricornus',
        structured_answer => {
            input     => ['31 Dec 2100'],
            operation => 'Zodiac',
            result    => 'Capricornus'
        }
    ),

    '1 Jan zodiac'         => test_zci(
	'Zodiac for 01 Jan 2015: Capricornus',
        structured_answer => {
            input     => ['01 Jan 2015'],
            operation => 'Zodiac',
            result    => 'Capricornus'
        }
    ),

    #Test Aquarius
    '20 Jan star sign' => test_zci(
	'Zodiac for 20 Jan 2015: Aquarius',
        structured_answer => {
            input     => ['20 Jan 2015'],
            operation => 'Zodiac',
            result    => 'Aquarius'
        }
    ),

    'Zodiac 21st Jan'  => test_zci(
	'Zodiac for 21 Jan 2015: Aquarius',
        structured_answer => {
            input     => ['21 Jan 2015'],
            operation => 'Zodiac',
            result    => 'Aquarius'
        }
    ),

    'StarSign 1st Feb' => test_zci(
	'Zodiac for 01 Feb 2015: Aquarius',
        structured_answer => {
            input     => ['01 Feb 2015'],
            operation => 'Zodiac',
            result    => 'Aquarius'
        }
    ),

    #Test Pisces
    '19 Feb star sign'     => test_zci(
	'Zodiac for 19 Feb 2015: Pisces',
        structured_answer => {
            input     => ['19 Feb 2015'],
            operation => 'Zodiac',
            result    => 'Pisces'
        }
    ),

    'Zodiac 20th Feb 1967' => test_zci(
	'Zodiac for 20 Feb 1967: Pisces',
        structured_answer => {
            input     => ['20 Feb 1967'],
            operation => 'Zodiac',
            result    => 'Pisces'
        }
     ),
    'StarSign 1st Mar'     => test_zci(
	'Zodiac for 01 Mar 2015: Pisces',
        structured_answer => {
            input     => ['01 Mar 2015'],
            operation => 'Zodiac',
            result    => 'Pisces'
        }
     ),

    '20 Mar star sign'     => test_zci(
	'Zodiac for 20 Mar 2015: Pisces',
        structured_answer => {
            input     => ['20 Mar 2015'],
            operation => 'Zodiac',
            result    => 'Pisces'
        }
     ),

    #Test Invalid Inputs
    '31st April 1876 zodiac' => undef,
    'Zodiac 31Feb'           => undef,
    'Zodiac 5thMay1200'      => undef,

);

done_testing;
