package DDG::Goodie::CubePatterns;

use DDG::Goodie;

triggers start => "cube";

zci is_cached => 1;

handle remainder => sub {
	if ($_ eq "stripes")
	{
		return "F U F R L2 B D' R D2 L D' B R2 L F U F";
	}
	elsif ($_ eq "in a cube")
	{
		return "F L F U' R U F2 L2 U' L' B D' B' L2 U";
	}
	return;
};
1;
