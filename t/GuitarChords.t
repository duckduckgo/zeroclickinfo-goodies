#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'guitarchord';
zci is_cached => 1;

ddg_goodie_test(
    [ 'DDG::Goodie::GuitarChords' ],
    'G#m6 guitar chord' => test_zci(
            'G#m6',
            heading=>'G#m6',
            html => qr#.*Guitar chord diagram for G\#m6.*#s
    ),
    'Abaug7 guitar chord' => test_zci(
            'Abaug7',
            heading=>'Abaug7',
            html => qr#.*Guitar chord diagram for Abaug7.*#s
    ),
    'A7/b9 guitar chord' => test_zci(
            'A7(b9)',
            heading=>'A7(b9)',
            html => qr#.*Guitar chord diagram for A7\(b9\).*#s
    ),
    'guitar chord Cm7' => test_zci(
            'Cm7',
            heading=>'Cm7',
            html => qr#.*Guitar chord diagram for Cm7.*#s
    ),
    'guitar chord Db7sus4' => test_zci(
            'Db7sus4',
            heading=>'Db7sus4',
            html => qr#.*Guitar chord diagram for Db7sus4.*#s
    ),
    'guitar chord f min' => test_zci(
            'Fm',
            heading=>'Fm',
            html => qr#.*Guitar chord diagram for Fm.*#s
    ),
    # check that certain things don't trigger it:
    'C# programming' => undef,
    'C programming' => undef,
    'D programming' => undef,
    'guitar chord finder' => undef,
    'guitar chord fminute' => undef,
    'G' => undef
);

done_testing;
