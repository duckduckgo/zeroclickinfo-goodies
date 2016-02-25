#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rubiks_cube';
zci is_cached   => 1;

my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

ddg_goodie_test(
    [qw(DDG::Goodie::RubiksCubePatterns)],
    'rubics cube stripes' => test_zci(
        "Stripes: F U F R L2 B D' R D2 L D' B R2 L F U F \n",
        structured_answer => {
            id => 'rubiks_cube_patterns',
            name => 'Answer',
            data => [
                {
                    title => "F U F R L2 B D' R D2 L D' B R2 L F U F",
                    description => "Rubiks cube 'Stripes' pattern",
                    image => "/share/goodie/rubiks_cube_patterns/$goodieVersion/stripes.svg",                    
                }
            ],
            templates => {
                group => 'info',
                variants => {
                    tile => 'poster'
                }
            }
        }
    ),
    'rubiks cube cube in a cube' => test_zci(
        "Cube in a Cube: F L F U' R U F2 L2 U' L' B D' B' L2 U \n",
        structured_answer => {
            id => 'rubiks_cube_patterns',
            name => 'Answer',
            data => [
                {
                    title => "F L F U' R U F2 L2 U' L' B D' B' L2 U",
                    description => "Rubiks cube 'Cube in a Cube' pattern",
                    image => "/share/goodie/rubiks_cube_patterns/$goodieVersion/cube_in_a_cube.svg",                   
                }
            ],
            templates => {
                group => 'info',
                variants => {
                    tile => 'poster'
                }
            }
        }
    ),
    'rubic cube swap centers' => test_zci(
        "Swap Centers: U D' R L' F B' U D' \n",
        structured_answer => {
            id => 'rubiks_cube_patterns',
            name => 'Answer',
            data => [
                {
                    title => "U D' R L' F B' U D'",
                    description => "Rubiks cube 'Swap Centers' pattern",
                    image => "/share/goodie/rubiks_cube_patterns/$goodieVersion/swap_centers.svg",                   
                }
            ],
            templates => {
                group => 'info',
                variants => {
                    tile => 'poster'
                }
            }
        }
    ),
    'rubiks cube in a cube' => test_zci(
        "Cube in a Cube: F L F U' R U F2 L2 U' L' B D' B' L2 U \n",
        structured_answer => {
            id => 'rubiks_cube_patterns',
            name => 'Answer',
            data => [
                {
                    title => "F L F U' R U F2 L2 U' L' B D' B' L2 U",
                    description => "Rubiks cube 'Cube in a Cube' pattern",
                    image => "/share/goodie/rubiks_cube_patterns/$goodieVersion/cube_in_a_cube.svg",                   
                }
            ],
            templates => {
                group => 'info',
                variants => {
                    tile => 'poster'
                }
            }
        }
    ),
    'rubiks cube in a cube in a cube' => test_zci(
        "Cube in a Cube in a Cube: U' L' U' F' R2 B' R F U B2 U B' L U' F U R F' \n",
        structured_answer => {
            id => 'rubiks_cube_patterns',
            name => 'Answer',
            data => [
                {
                    title => "U' L' U' F' R2 B' R F U B2 U B' L U' F U R F'",
                    description => "Rubiks cube 'Cube in a Cube in a Cube' pattern",
                    image => "/share/goodie/rubiks_cube_patterns/$goodieVersion/cube_in_a_cube_in_a_cube.svg",                  
                }
            ],
            templates => {
                group => 'info',
                variants => {
                    tile => 'poster'
                }
            }
        }
    ),
    'rcube stripes' => test_zci(
        "Stripes: F U F R L2 B D' R D2 L D' B R2 L F U F \n",
        structured_answer => {
            id => 'rubiks_cube_patterns',
            name => 'Answer',
            data => [
                {
                    title => "F U F R L2 B D' R D2 L D' B R2 L F U F",
                    description => "Rubiks cube 'Stripes' pattern",
                    image => "/share/goodie/rubiks_cube_patterns/$goodieVersion/stripes.svg",                   
                }
            ],
            templates => {
                group => 'info',
                variants => {
                    tile => 'poster'
                }
            }
        }
    ),
    'rcube cube in a cube' => test_zci(
        "Cube in a Cube: F L F U' R U F2 L2 U' L' B D' B' L2 U \n",
        structured_answer => {
            id => 'rubiks_cube_patterns',
            name => 'Answer',
            data => [
                {
                    title => "F L F U' R U F2 L2 U' L' B D' B' L2 U",
                    description => "Rubiks cube 'Cube in a Cube' pattern",
                    image => "/share/goodie/rubiks_cube_patterns/$goodieVersion/cube_in_a_cube.svg",                  
                }
            ],
            templates => {
                group => 'info',
                variants => {
                    tile => 'poster'
                }
            }
        }
    ),
    'rcube swap centers' => test_zci(
        "Swap Centers: U D' R L' F B' U D' \n",
        structured_answer => {
            id => 'rubiks_cube_patterns',
            name => 'Answer',
            data => [
                {
                    title => "U D' R L' F B' U D'",
                    description => "Rubiks cube 'Swap Centers' pattern",
                    image => "/share/goodie/rubiks_cube_patterns/$goodieVersion/swap_centers.svg",,                  
                }
            ],
            templates => {
                group => 'info',
                variants => {
                    tile => 'poster'
                }
            }
        }
    ),
    'rcube swap cented' => undef,
    'rcube cube in a cuve' => undef,
    'rubiks cube other words' => undef,
    'rubics cube' => undef,
);

done_testing;
