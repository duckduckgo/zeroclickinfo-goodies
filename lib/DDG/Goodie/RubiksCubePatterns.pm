package DDG::Goodie::RubiksCubePatterns;
# ABSTRACT: Create interesting patterns from a solved Rubik's Cube.

use DDG::Goodie;


primary_example_queries 'rcube stripes';
secondary_example_queries 'rcube cube in a cube', 'rcube swap centers';
description "create interesting patterns from a solved Rubik's Cube";
name 'Rubiks Cube';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/RubiksCubePatterns.pm';
category 'random';
topics 'special_interest';
source 'http://math.cos.ucf.edu/~reid/Rubik/patterns.html';
attribution web => ['robert.io', 'Robert Picard'], 
            twitter => ['__rlp', 'Robert Picard'], 
            github => ['rpicard', 'Robert Picard'];

triggers start =>	"rcube", "rubik", "rubiks", "rubix",
					"rubicks", "rubik's", "rubic's", "rubick's",
					"rubik cube", "rubiks cube", "rubic cube", "rubics cube",
					"rubik's cube patterns", "rubiks cube patterns";

zci answer_type => "rubiks_cube";
zci is_cached   => 1;

our %patterns = (
	"stripes" => "F U F R L2 B D' R D2 L D' B R2 L F U F",
	"crosses" => "U F B' L2 U2 L2 F' B U2 L2 U",
	"swap centers" => "U D' R L' F B' U D'",
	"checkerboard" => "F2 B2 R2 L2 U2 D2",
	"cube in a cube" => "F L F U' R U F2 L2 U' L' B D' B' L2 U",
	"cube in a cube in a cube" => "U' L' U' F' R2 B' R F U B2 U B' L U' F U R F'",
	"exchanged peaks" => "F2 R2 D R2 U D F2 D' R' D' F L2 F' D R U'",
	"t's" => "F2 R2 U2 F' B D2 L2 F B",
	"anaconda" => "L U B' U' R L' B R' F B' D R D' F'",
	"python" => "F2 R' B' U R' L F' L F' B D' R B L2",
	"black mamba" => "R D L F' R L' D R' U D' B U' R' D'",
);

sub to_titlecase($)
{
	$a = pop;
	$a =~ s/(\w\S*)/\u\L$1/g;
	$a =~ s/ In / in /g;
	$a =~ s/ A / a /g;
	return $a;
}

sub render_text($) {
	my $name = pop;
	return to_titlecase($name) . ": $patterns{$name} \n";
}

sub render_html($) {
	my $name = pop;
	my $output = "<div><i>" . to_titlecase($name) . "</i>";
	$output .= ": $patterns{$name}</div>\n";
	return $output;
}

handle remainder => sub {

	$_ = lc($_);

	#support British English!
	s/centre/center/;

	#hack for the trigger "rubiks cube in a cube"
	s/^in a cube/cube in a cube/;

	#show answer
	return render_text($_), html => render_html($_) if ($patterns{$_});

	#display the cheatsheet
	my $output = my $html_output = "";
	foreach my $pattern (keys %patterns) {
		$output .= render_text($pattern);
		$html_output .= render_html($pattern);
	}

	return $output, html => $html_output, heading => "Rubik's Cube Patterns";
};

1;
