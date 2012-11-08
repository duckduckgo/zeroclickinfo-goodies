package DDG::Goodie::RubiksCubePatterns;

use DDG::Goodie;

# Create interesting patterns from a solved Rubik's Cube.

primary_example_queries 'rcube stripes';
secondary_example_queries 'rcube cube in a cube', 'rcube swap centers';
description 'create interesting patterns from a solved Rubik\'s Cube';
name 'Rubiks Cube';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/RubiksCubePatterns.pm';
category 'random';
topics 'special_interest';

attribution web => ['robert.io', 'Robert Picard'], twitter => '__rlp', github => ['https://github.com/rpicard', 'rpicard'];

triggers start => "rcube";

zci is_cached => 1;
zci answer_type => "rubiks_cube";

handle remainder => sub {
	return "F U F R L2 B D' R D2 L D' B R2 L F U F" if lc($_) eq "stripes";
	return "F L F U' R U F2 L2 U' L' B D' B' L2 U" if lc($_) eq "cube in a cube";
	return "U D' R L' F B' U D'" if lc($_) eq "swap centers";
	return;
};

1;
