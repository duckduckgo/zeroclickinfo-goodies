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
            structured_answer => {
                id => 'rubiks_cube_patterns',
                name => 'Answer',
                data => {
                    record_data => {'stripes:', "F U F R L2 B D' R D2 L D' B R2 L F U F"},                   
                },
                templates => {
                    group => 'list',
                    options => {
                        content => 'record',
                    }
                }
            }
       	),
        'rubiks cube cube in a cube' => test_zci(
        	"Cube in a Cube: F L F U' R U F2 L2 U' L' B D' B' L2 U \n",
            structured_answer => {
                id => 'rubiks_cube_patterns',
                name => 'Answer',
                data => {
                    record_data => {'cube in a cube:', "F L F U' R U F2 L2 U' L' B D' B' L2 U"},                   
                },
                templates => {
                    group => 'list',
                    options => {
                        content => 'record',
                    }
                }
            }
        	#"html" => "<div><i>Cube in a Cube</i>: F L F U' R U F2 L2 U' L' B D' B' L2 U</div>\n"
        ),
        'rubic cube swap centers' => test_zci(
        	"Swap Centers: U D' R L' F B' U D' \n",
            structured_answer => {
                id => 'rubiks_cube_patterns',
                name => 'Answer',
                data => {
                    record_data => {'swap centers:', "U D' R L' F B' U D'"},                   
                },
                templates => {
                    group => 'list',
                    options => {
                        content => 'record',
                    }
                }
            }
        	#"html" => "<div><i>Swap Centers</i>: U D' R L' F B' U D'</div>\n"
        ),
        'rubiks cube in a cube' => test_zci(
        	"Cube in a Cube: F L F U' R U F2 L2 U' L' B D' B' L2 U \n",
            structured_answer => {
                id => 'rubiks_cube_patterns',
                name => 'Answer',
                data => {
                    record_data => {'cube in a cube:', "F L F U' R U F2 L2 U' L' B D' B' L2 U"},                   
                },
                templates => {
                    group => 'list',
                    options => {
                        content => 'record',
                    }
                }
            }
        	#"html" => "<div><i>Cube in a Cube</i>: F L F U' R U F2 L2 U' L' B D' B' L2 U</div>\n"
        ),
        'rubiks cube in a cube in a cube' => test_zci(
        	"Cube in a Cube in a Cube: U' L' U' F' R2 B' R F U B2 U B' L U' F U R F' \n",
            structured_answer => {
                id => 'rubiks_cube_patterns',
                name => 'Answer',
                data => {
                    record_data => {'cube in a cube in a cube:', "U' L' U' F' R2 B' R F U B2 U B' L U' F U R F'"},                   
                },
                templates => {
                    group => 'list',
                    options => {
                        content => 'record',
                    }
                }
            }
        	#"html" => "<div><i>Cube in a Cube in a Cube</i>: U' L' U' F' R2 B' R F U B2 U B' L U' F U R F'</div>\n"
        ),
        'rcube stripes' => test_zci(
            "Stripes: F U F R L2 B D' R D2 L D' B R2 L F U F \n",
            structured_answer => {
                id => 'rubiks_cube_patterns',
                name => 'Answer',
                data => {
                    record_data => {'stripes:', "F U F R L2 B D' R D2 L D' B R2 L F U F"},                   
                },
                templates => {
                    group => 'list',
                    options => {
                        content => 'record',
                    }
                }
            }
            #html => "<div><i>Stripes</i>: F U F R L2 B D' R D2 L D' B R2 L F U F</div>\n",
        ),
        'rcube cube in a cube' => test_zci(
            "Cube in a Cube: F L F U' R U F2 L2 U' L' B D' B' L2 U \n",
            structured_answer => {
                id => 'rubiks_cube_patterns',
                name => 'Answer',
                data => {
                    record_data => {'cube in a cube:', "F L F U' R U F2 L2 U' L' B D' B' L2 U"},                   
                },
                templates => {
                    group => 'list',
                    options => {
                        content => 'record',
                    }
                }
            }
            #html => "<div><i>Cube in a Cube</i>: F L F U' R U F2 L2 U' L' B D' B' L2 U</div>\n",
        ),
        'rcube swap centers' => test_zci(
            "Swap Centers: U D' R L' F B' U D' \n",
            structured_answer => {
                id => 'rubiks_cube_patterns',
                name => 'Answer',
                data => {
                    record_data => {'swap centers:', "U D' R L' F B' U D'"},                   
                },
                templates => {
                    group => 'list',
                    options => {
                        content => 'record',
                    }
                }
            }
            #html => "<div><i>Swap Centers</i>: U D' R L' F B' U D'</div>\n",
        ),
);

done_testing;
