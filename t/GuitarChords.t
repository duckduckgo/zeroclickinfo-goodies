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
            html => qr#<img src='data:image/png;base64,.*'/>#s
    ),
    'Abaug7 guitar chord' => test_zci(
            'Abaug7',
            heading=>'Abaug7',
            html => qr#<img src='data:image/png;base64,.*'/>#s
    ),
    'A#add9 guitar chord' => test_zci(
            'G#m6',
            heading=>'G#m6',
            html => qr#<img src='data:image/png;base64,.*'/>#s
    ),
    'A7 b9 guitar chord' => test_zci(
            'A7(b9)',
            heading=>'A7(b9)',
            html => qr#<img src='data:image/png;base64,.*'/>#s
    ),
    'guitar chord Cm7' => test_zci(
            'Cm7',
            heading=>'Cm7',
            html => qr#<img src='data:image/png;base64,.*'/>#s
    ),
    'Dbdim guitar chord' => test_zci(
            'Dbdim',
            heading=>'Dbdim',
            html => qr#<img src='data:image/png;base64,.*'/>#s
    ),
    'g guitar chord' => test_zci(
            'G',
            heading=>'G',
            html => qr#<img src='data:image/png;base64,.*'/>#s
    )
);

done_testing;
