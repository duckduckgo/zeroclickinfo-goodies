package DDG::Goodie::SquareRoot;
# Returns square of remainder

use Math::Complex;
use DDG::Goodie;


primary_example_queries 'square root of 4', "square root 25";
secondary_example_queries 'sqrt 4', "Sqrt 25";
description 'Calculates the square root of a number locally and quickly.';
name 'Square Root';
code_url 'https://github.com/JackWinch/zeroclickinfo-goodies/lib/DDG/Goodie/SquareRoot.pm';
category 'calculations';
topics 'science';

zci answer_type => "number";
zci is_cached => 1;

triggers start => 'sqrt', 'Sqrt', 'square root', 'square root of';

handle remainder => sub {
	if($_){
		if ($_ !~ /[A-Z]/ and $_ !~ /[a-z]/) {
			
			my $square = sqrt($_);

			return answer => $square, html => "<h6>The square root of $_</h6><h2><strong> = $square</strong></h2><hr><p><span>In mathematics, a square root of a number a is a number y such that y^(2) = a, in other words, a number y whose square is a. For example, 4 and −4 are square roots of 16 because 4^(2) = 16. </span><br><br/>Read more at <a href = 'http://en.wikipedia.org/wiki/Square_root'>Wikipedia.</a></p>";
		}
	}
    return;
};
1;
