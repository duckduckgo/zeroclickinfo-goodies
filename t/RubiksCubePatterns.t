#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rubiks_cube';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::RubiksCubePatterns
        )],
        'rcube stripes' => test_zci("F U F R L2 B D' R D2 L D' B R2 L F U F" ),
        'rcube cube in a cube' => test_zci("F L F U' R U F2 L2 U' L' B D' B' L2 U" ),
        'rcube swap centers' => test_zci("U D' R L' F B' U D'" )
);

done_testing;
