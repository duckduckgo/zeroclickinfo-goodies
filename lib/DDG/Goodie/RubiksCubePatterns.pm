package DDG::Goodie::RubiksCubePatterns;

use DDG::Goodie;

# Create interesting patterns from a solved Rubik's Cube.

triggers start => "rcube";

zci is_cached => 1;

handle remainder => sub {
	return "F U F R L2 B D' R D2 L D' B R2 L F U F" if lc($_) eq "stripes";
	return "F L F U' R U F2 L2 U' L' B D' B' L2 U" if lc($_) eq "cube in a cube";
	return "U D' R L' F B' U D'" if lc($_) eq "swap centers";
	return;
};
1;
