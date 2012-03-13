package DDG::Goodie::CubePatterns;

use DDG::Goodie;

triggers start => "cube";

zci is_cached => 1;

handle remainder => sub {
	return "F U F R L2 B D' R D2 L D' B R2 L F U F" if $_ eq "stripes";
	return "F L F U' R U F2 L2 U' L' B D' B' L2 U" if $_ eq "in a cube";
	return "U D' R L' F B' U D'" if $_ eq "swap centers";
	return;
};
1;
