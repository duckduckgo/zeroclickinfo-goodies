#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'chord_diagrams';
zci is_cached => 1;

ddg_goodie_test(
[ 'DDG::Goodie::ChordDiagrams' ],
'Amaj9 guitar chord' => test_zci(
'chord_diagrams',
structured_answer => {
    id => 'chord_diagrams',
    name => 'Music',
    data => re(qr/.*/),
    templates => {
        group => "base",
        detail => 0,
        options => {
            content => 'DDH.chord_diagrams.detail'
        },
        variants => {
            tile => 'narrow'
        }
    },
}),
'Cm ukulele chord' => test_zci(
'chord_diagrams',
structured_answer => {
    id => 'chord_diagrams',
    name => 'Music',
    data => re(qr/.*/),
    templates => {
        group => "base",
        detail => 0,
        options => {
            content => 'DDH.chord_diagrams.detail'
        },
        variants => {
            tile => 'narrow'
        }
    },
}),
'Eb uke tabs' => test_zci(
'chord_diagrams',
structured_answer => {
    id => 'chord_diagrams',
    name => 'Music',
    data => re(qr/.*/),
    templates => {
        group => "base",
        detail => 0,
        options => {
            content => 'DDH.chord_diagrams.detail'
        },
        variants => {
            tile => 'narrow'
        }
    },
}),
'A   major guitar tab' => test_zci(
'chord_diagrams',
structured_answer => {
    id => 'chord_diagrams',
    name => 'Music',
    data => re(qr/.*/),
    templates => {
        group => "base",
        detail => 0,
        options => {
            content => 'DDH.chord_diagrams.detail'
        },
        variants => {
            tile => 'narrow'
        }
    },
}),
# check that certain things don't trigger it:
'C# programming' => undef,
'C programming' => undef,
'D programming' => undef,
'guitar chord finder' => undef,
'guitar chord fminute' => undef,
'G' => undef,
'A sharp tabs' => undef,
'randomstring guitar chords' => undef
);

done_testing;
