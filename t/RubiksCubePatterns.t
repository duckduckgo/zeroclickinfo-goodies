#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rubiks_cube';

ddg_goodie_test(
        [qw(
                DDG::Goodie::RubiksCubePatterns
        )],
        'rubics cube stripes' => test_zci(
        	"stripes: F U F R L2 B D' R D2 L D' B R2 L F U F \n",
        	"html" => "<p><i>stripes</i>: F U F R L2 B D' R D2 L D' B R2 L F U F</p>\n"
       	),
        'rubiks cube cube in a cube' => test_zci(
        	"cube in a cube: F L F U' R U F2 L2 U' L' B D' B' L2 U \n",
        	"html" => "<p><i>cube in a cube</i>: F L F U' R U F2 L2 U' L' B D' B' L2 U</p>\n"
        ),
        'rubic cube swap centers' => test_zci(
        	"swap centers: U D' R L' F B' U D' \n",
        	"html" => "<p><i>swap centers</i>: U D' R L' F B' U D'</p>\n"
        ),
        'rubiks cube in a cube' => test_zci(
        	"cube in a cube: F L F U' R U F2 L2 U' L' B D' B' L2 U \n",
        	"html" => "<p><i>cube in a cube</i>: F L F U' R U F2 L2 U' L' B D' B' L2 U</p>\n"
        ),
        'rubiks cube in a cube in a cube' => test_zci(
        	"cube in a cube in a cube: U' L' U' F' R2 B' R F U B2 U B' L U' F U R F' \n",
        	"html" => "<p><i>cube in a cube in a cube</i>: U' L' U' F' R2 B' R F U B2 U B' L U' F U R F'</p>\n"
        ),
);

done_testing;
