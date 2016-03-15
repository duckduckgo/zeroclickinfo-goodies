#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

use DDG::Goodie::Zodiac;

my $goodie_version = $DDG::Goodie::Zodiac::zodiac_goodie_version;

sub build_structured_answer {
    my ($result, $image, $formatted) = @_;
    return $result,
        structured_answer => {
            id   => "zodiac",
            name => "Answer",
            data => {
                image    => "/share/goodie/zodiac/$goodie_version/" . lc($result) . ".png",
                title    => $result,
                subtitle => $formatted,
            },
            templates => {
                group   => 'icon',
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
    'Zodiac 21st March 1967' => build_test('Aries', 'bg-clr--red circle', 'Zodiac for 21 Mar 1967'),
    'StarSign 30 Mar'        => build_test('Aries', 'bg-clr--red circle', 'Zodiac for 30 Mar 2015'),
    '20 April star sign'     => build_test('Aries', 'bg-clr--red circle', 'Zodiac for 20 Apr 2015'),

    # Taurus
    'Zodiac 21st April 2014' => build_test('Taurus', 'bg-clr--green circle', 'Zodiac for 21 Apr 2014'),
    'StarSign 27 Apr'        => build_test('Taurus', 'bg-clr--green circle', 'Zodiac for 27 Apr 2015'),

    # Gemini
    '21 May star sign'     => build_test('Gemini', 'bg-clr--grey circle', 'Zodiac for 21 May 2015'),
    'Zodiac 22nd May 1500' => build_test('Gemini', 'bg-clr--grey circle', 'Zodiac for 22 May 1500'),
    'Zodiac 21.05.1965'    => build_test('Gemini', 'bg-clr--grey circle', 'Zodiac for 21 May 1965'),
    'StarSign 31 May'      => build_test('Gemini', 'bg-clr--grey circle', 'Zodiac for 31 May 2015'),
    '21 jun star sign'     => build_test('Gemini', 'bg-clr--grey circle', 'Zodiac for 21 Jun 2015'),

    # Cancer
    'Zodiac 22nd June 1889' => build_test('Cancer', 'bg-clr--blue-light circle', 'Zodiac for 22 Jun 1889'),
    'StarSign 30 June 2017' => build_test('Cancer', 'bg-clr--blue-light circle', 'Zodiac for 30 Jun 2017'),
    '22nd july star sign'   => build_test('Cancer', 'bg-clr--blue-light circle', 'Zodiac for 22 Jul 2015'),

    # Leo
    'Zodiac 23 July 1654'  => build_test('Leo', 'bg-clr--red circle', 'Zodiac for 23 Jul 1654'),
    'StarSign 24th July'   => build_test('Leo', 'bg-clr--red circle', 'Zodiac for 24 Jul 2015'),
    '22 aug star sign'     => build_test('Leo', 'bg-clr--red circle', 'Zodiac for 22 Aug 2015'),
    'Zodiac 23rd Aug 1700' => build_test('Leo', 'bg-clr--red circle', 'Zodiac for 23 Aug 1700'),

    # Virgo
    'StarSign 1 Sep' => build_test('Virgo', 'bg-clr--green circle', 'Zodiac for 01 Sep 2015'),

    # Libra
    '23rd Sep star sign'       => build_test('Libra', 'bg-clr--grey circle', 'Zodiac for 23 Sep 2015'),
    'Zodiac 24 September 2001' => build_test('Libra', 'bg-clr--grey circle', 'Zodiac for 24 Sep 2001'),
    'StarSign 7th October'     => build_test('Libra', 'bg-clr--grey circle', 'Zodiac for 07 Oct 2015'),

    # Scorpius
    '23 oct star sign'       => build_test('Scorpius', 'bg-clr--blue-light circle', 'Zodiac for 23 Oct 2015'),
    'Zodiac 24 October 1213' => build_test('Scorpius', 'bg-clr--blue-light circle', 'Zodiac for 24 Oct 1213'),
    'StarSign 9th November'  => build_test('Scorpius', 'bg-clr--blue-light circle', 'Zodiac for 09 Nov 2015'),

    # Sagittarius
    '22 nov star sign'   => build_test('Sagittarius', 'bg-clr--red circle', 'Zodiac for 22 Nov 2015'),
    'Zodiac 23 Nov 1857' => build_test('Sagittarius', 'bg-clr--red circle', 'Zodiac for 23 Nov 1857'),
    'StarSign 6 Dec'     => build_test('Sagittarius', 'bg-clr--red circle', 'Zodiac for 06 Dec 2015'),
    '21 Dec star sign'   => build_test('Sagittarius', 'bg-clr--red circle', 'Zodiac for 21 Dec 2015'),

    # Capricornus
    'Zodiac 22nd December' => build_test('Capricornus', 'bg-clr--green circle', 'Zodiac for 22 Dec 2015'),
    'StarSign 23 Dec 1378' => build_test('Capricornus', 'bg-clr--green circle', 'Zodiac for 23 Dec 1378'),
    'starsign 31 Dec 2009' => build_test('Capricornus', 'bg-clr--green circle', 'Zodiac for 31 Dec 2009'),
    '31.12.2100 zodiac'    => build_test('Capricornus', 'bg-clr--green circle', 'Zodiac for 31 Dec 2100'),
    '1 Jan zodiac'         => build_test('Capricornus', 'bg-clr--green circle', 'Zodiac for 01 Jan 2015'),

    # Aquarius
    '20 Jan star sign' => build_test('Aquarius', 'bg-clr--grey circle', 'Zodiac for 20 Jan 2015'),
    'Zodiac 21st Jan'  => build_test('Aquarius', 'bg-clr--grey circle', 'Zodiac for 21 Jan 2015'),
    'StarSign 1st Feb' => build_test('Aquarius', 'bg-clr--grey circle', 'Zodiac for 01 Feb 2015'),

    # Pisces
    '19 Feb star sign'     => build_test('Pisces', 'bg-clr--blue-light circle', 'Zodiac for 19 Feb 2015'),
    'Zodiac 20th Feb 1967' => build_test('Pisces', 'bg-clr--blue-light circle', 'Zodiac for 20 Feb 1967'),
    'StarSign 1st Mar'     => build_test('Pisces', 'bg-clr--blue-light circle', 'Zodiac for 01 Mar 2015'),
    '20 Mar star sign'     => build_test('Pisces', 'bg-clr--blue-light circle', 'Zodiac for 20 Mar 2015'),

    # Invalid Inputs
    '31st April 1876 zodiac' => undef,
    'Zodiac 31Feb'           => undef,
    'Zodiac 5thMay1200'      => undef,

);

restore_time();

done_testing;
