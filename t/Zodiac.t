#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

sub build_structured_answer {
    my ($image, $formatted) = @_;
    return $formatted,
        structured_answer => {
            id => "zodiac",
            name => "Answer",
            data => '-ANY-',
            templates => {
                group => 'icon',
                elClass => {
                    iconImage => $image,
                },
                variants => {
                     iconImage => 'large'
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

set_fixed_time("2015-12-30T00:00:00");
zci answer_type => 'zodiac';
ddg_goodie_test([ qw( DDG::Goodie::Zodiac ) ],

    # Aries
    'Zodiac 21st March 1967' => build_test('bg-clr--red circle', 'Zodiac for 21 Mar 1967: Aries'),
    'StarSign 30 Mar'        => build_test('bg-clr--red circle', 'Zodiac for 30 Mar 2015: Aries'),
    '20 April star sign'     => build_test('bg-clr--red circle', 'Zodiac for 20 Apr 2015: Aries'),

    # Taurus
    'Zodiac 21st April 2014' => build_test('bg-clr--green circle', 'Zodiac for 21 Apr 2014: Taurus'),
    'StarSign 27 Apr'        => build_test('bg-clr--green circle', 'Zodiac for 27 Apr 2015: Taurus'),

    # Gemini
    '21 May star sign'     => build_test('bg-clr--grey circle', 'Zodiac for 21 May 2015: Gemini'),
    'Zodiac 22nd May 1500' => build_test('bg-clr--grey circle', 'Zodiac for 22 May 1500: Gemini'),
    'Zodiac 21.05.1965'    => build_test('bg-clr--grey circle', 'Zodiac for 21 May 1965: Gemini'),
    'StarSign 31 May'      => build_test('bg-clr--grey circle', 'Zodiac for 31 May 2015: Gemini'),
    '21 jun star sign'     => build_test('bg-clr--grey circle', 'Zodiac for 21 Jun 2015: Gemini'),

    # Cancer
    'Zodiac 22nd June 1889' => build_test('bg-clr--blue-light circle', 'Zodiac for 22 Jun 1889: Cancer'),
    'StarSign 30 June 2017' => build_test('bg-clr--blue-light circle', 'Zodiac for 30 Jun 2017: Cancer'),
    '22nd july star sign'   => build_test('bg-clr--blue-light circle', 'Zodiac for 22 Jul 2015: Cancer'),

    # Leo
    'Zodiac 23 July 1654'  => build_test('bg-clr--red circle', 'Zodiac for 23 Jul 1654: Leo'),
    'StarSign 24th July'   => build_test('bg-clr--red circle', 'Zodiac for 24 Jul 2015: Leo'),
    '22 aug star sign'     => build_test('bg-clr--red circle', 'Zodiac for 22 Aug 2015: Leo'),
    'Zodiac 23rd Aug 1700' => build_test('bg-clr--red circle', 'Zodiac for 23 Aug 1700: Leo'),

    # Virgo
    'StarSign 1 Sep' => build_test('bg-clr--green circle', 'Zodiac for 01 Sep 2015: Virgo'),

    # Libra
    '23rd Sep star sign'       => build_test('bg-clr--grey circle', 'Zodiac for 23 Sep 2015: Libra'),
    'Zodiac 24 September 2001' => build_test('bg-clr--grey circle', 'Zodiac for 24 Sep 2001: Libra'),
    'StarSign 7th October'     => build_test('bg-clr--grey circle', 'Zodiac for 07 Oct 2015: Libra'),

    # Scorpius
    '23 oct star sign'       => build_test('bg-clr--blue-light circle', 'Zodiac for 23 Oct 2015: Scorpius'),
    'Zodiac 24 October 1213' => build_test('bg-clr--blue-light circle', 'Zodiac for 24 Oct 1213: Scorpius'),
    'StarSign 9th November'  => build_test('bg-clr--blue-light circle', 'Zodiac for 09 Nov 2015: Scorpius'),

    # Sagittarius
    '22 nov star sign'   => build_test('bg-clr--red circle', 'Zodiac for 22 Nov 2015: Sagittarius'),
    'Zodiac 23 Nov 1857' => build_test('bg-clr--red circle', 'Zodiac for 23 Nov 1857: Sagittarius'),
    'StarSign 6 Dec'     => build_test('bg-clr--red circle', 'Zodiac for 06 Dec 2015: Sagittarius'),
    '21 Dec star sign'   => build_test('bg-clr--red circle', 'Zodiac for 21 Dec 2015: Sagittarius'),

    # Capricornus
    'Zodiac 22nd December' => build_test('bg-clr--green circle', 'Zodiac for 22 Dec 2015: Capricornus'),
    'StarSign 23 Dec 1378' => build_test('bg-clr--green circle', 'Zodiac for 23 Dec 1378: Capricornus'),
    'starsign 31 Dec 2009' => build_test('bg-clr--green circle', 'Zodiac for 31 Dec 2009: Capricornus'),
    '31.12.2100 zodiac'    => build_test('bg-clr--green circle', 'Zodiac for 31 Dec 2100: Capricornus'),
    '1 Jan zodiac'         => build_test('bg-clr--green circle', 'Zodiac for 01 Jan 2015: Capricornus'),

    # Aquarius
    '20 Jan star sign' => build_test('bg-clr--grey circle', 'Zodiac for 20 Jan 2015: Aquarius'),
    'Zodiac 21st Jan'  => build_test('bg-clr--grey circle', 'Zodiac for 21 Jan 2015: Aquarius'),
    'StarSign 1st Feb' => build_test('bg-clr--grey circle', 'Zodiac for 01 Feb 2015: Aquarius'),

    # Pisces
    '19 Feb star sign'     => build_test('bg-clr--blue-light circle', 'Zodiac for 19 Feb 2015: Pisces'),
    'Zodiac 20th Feb 1967' => build_test('bg-clr--blue-light circle', 'Zodiac for 20 Feb 1967: Pisces'),
    'StarSign 1st Mar'     => build_test('bg-clr--blue-light circle', 'Zodiac for 01 Mar 2015: Pisces'),
    '20 Mar star sign'     => build_test('bg-clr--blue-light circle', 'Zodiac for 20 Mar 2015: Pisces'),

    # Invalid Inputs
    '31st April 1876 zodiac' => undef,
    'Zodiac 31Feb'           => undef,
    'Zodiac 5thMay1200'      => undef,

);

restore_time();

done_testing;
