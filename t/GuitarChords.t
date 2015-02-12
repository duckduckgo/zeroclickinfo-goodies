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
    )
);

done_testing;
