#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rubiks_cube';
zci is_cached   => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::RubiksCubePatterns
        )],
        'rubics cube stripes' => test_zci(
        	"Stripes: F U F R L2 B D' R D2 L D' B R2 L F U F \n",
        	"html" => "<div><i>Stripes</i>: F U F R L2 B D' R D2 L D' B R2 L F U F</div>\n"
       	),
        'rubiks cube cube in a cube' => test_zci(
        	"Cube in a Cube: F L F U' R U F2 L2 U' L' B D' B' L2 U \n",
        	"html" => "<div><i>Cube in a Cube</i>: F L F U' R U F2 L2 U' L' B D' B' L2 U</div>\n"
        ),
        'rubic cube swap centers' => test_zci(
        	"Swap Centers: U D' R L' F B' U D' \n",
        	"html" => "<div><i>Swap Centers</i>: U D' R L' F B' U D'</div>\n"
        ),
        'rubiks cube in a cube' => test_zci(
        	"Cube in a Cube: F L F U' R U F2 L2 U' L' B D' B' L2 U \n",
        	"html" => "<div><i>Cube in a Cube</i>: F L F U' R U F2 L2 U' L' B D' B' L2 U</div>\n"
        ),
        'rubiks cube in a cube in a cube' => test_zci(
        	"Cube in a Cube in a Cube: U' L' U' F' R2 B' R F U B2 U B' L U' F U R F' \n",
        	"html" => "<div><i>Cube in a Cube in a Cube</i>: U' L' U' F' R2 B' R F U B2 U B' L U' F U R F'</div>\n"
        ),
        "rubik's cube patterns" => test_zci(
        	qr/.+: .+/s,
        	"html" => qr{<div><i>.+</i>: .+</div>}s,
        	"heading" => "Rubik's Cube Patterns"
        ),
        'rcube stripes' => test_zci(
            "Stripes: F U F R L2 B D' R D2 L D' B R2 L F U F \n",
            html => "<div><i>Stripes</i>: F U F R L2 B D' R D2 L D' B R2 L F U F</div>\n",
        ),
        'rcube cube in a cube' => test_zci(
            "Cube in a Cube: F L F U' R U F2 L2 U' L' B D' B' L2 U \n",
            html => "<div><i>Cube in a Cube</i>: F L F U' R U F2 L2 U' L' B D' B' L2 U</div>\n",
        ),
        'rcube swap centers' => test_zci(
            "Swap Centers: U D' R L' F B' U D' \n",
            html => "<div><i>Swap Centers</i>: U D' R L' F B' U D'</div>\n",
        ),
);

done_testing;
