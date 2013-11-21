package DDG::Goodie::Latex;
# ABSTRACT: Show the Latex command for a keyword

use DDG::Goodie;

triggers startend => 'latex', 'Latex', 'tex';
primary_example_queries 'latex summation';
description 'Show the Latex command for a keyword';
category 'programming';
topics 'programming', 'math';
name 'Latex';
topics 'special_interest';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Latex.pm';
attribution
    web => ['www.transistor.io', 'Jason Dorweiler'],
    github => [ 'jdorweiler', 'Jason_Dorweiler'];

zci is_cached => 1;
zci answer_type => 'Latex';

my %texCommands = (

	#Math operators
	"and" => ['logical AND', '\land', '$A \land B$'], 
	"or" =>  ['logical OR', '\lor', '$A \lor B$'],
	"not" => ['logical NOT', '\neg', '$\neg B$'],
	"less than or equal" => ['logical less than or equal', '\leq', '$A \leq B$'],  
	"less than" => ['logical less than', '<' , '$A < B$'],
	"union" => ['union', '\cap', '$A \cap B$'],
	"intersection" => ['intersection', '\cup', '$A \cup B$'],
	"implication" => ['implication', '\rightarrow', '$A \rightarrow B$'],
	"iff" => ['if and only if', '\leftrightarrow', '$A \leftrightarrow B$'],
	"if and only if" => ['if and only if', '\leftrightarrow', '$A \leftrightarrow B$'],

	#math functions
	"sum" => ['summation', '\sum_{lower}^{upper}', '$\sum{i=0}^{10} x^{2}$'],
	"summation" => ['summation', '\sum_{lower}^{upper}', '$\sum{i=0}^{10} x^{2}$'],
	"fraction" => ['fraction', '\frac{numerator}{denominator}', '$\frac{A}{B}$'],
	"limit" => ['limit', '\lim{bound}', '$\lim{x \to +\infty} 2x^{2}$'],
	"integral" => ['integral', '\int_lowerbound^upperbound', '$\int_a^b f(x)dx$'],
	"square root" => ['square root', '\sqrt[n][x]', '$\sqrt[n][x]$'],


	#math symbols
	"infinity" => ['infinity', '\infty', '$\infty$'],
	"dot" => ['center dots', '\cdot or \cdots', '$A+ \cdots +B$'],
	"alpha" => ['alpha', '\alpha', '$\alpha$'],
	"delta" => ['delta', '\delta (lower casee) or \Delta (upper case)', '$\delta$'],
	"zeta" => ['zeta', '\zeta', '$\zeta$'],
	"lambda" => ['lambda', '\lambda', '$\lambda$'],
	"xi" => ['xi', '\xi (lower case) or \Xi (upper case)', '$\xi$'],
	"sigma" => ['sigma', '\sigma (lower case) or \Sigma (upper case)', '$\sigma$'],
	"phi" => ['phi', '\phi (lower case) or \Phi (upper case)', '$\phi$'],
	"omega" => ['omega', '\omega (lower case) or \Omega (upper case)', '$\omega$'],

	#other
	"date" => ['date', '\today', '\today'],
	"new line" => ['new line', '\\', 'text... \\'],
	"subscript" => ['subscript', '_{x}', '$H_{2}O$'],
	"superscript" => ['superscript', '^{x}', '$x^{2}$'],
);

sub build_html{
	# builds a string to display using the given $command
	# and $usage 
	return "<i>Command:</i> $_[0] <br> <i>Usage:</i> $_[1]";
}

handle remainder => sub {
	my $key = lc $_; #set key to lower case
	my $command = $texCommands{$key}[1]; #get tex command from hash

	if($command) { #check to see if the key was in the table
	my $heading = $texCommands{$key}[0];	
	my $usage = $texCommands{$key}[2];

	#build the html string to display
	my $html = build_html($command, $usage);

	return $heading, html => $html, heading => "Latex command ($heading)";
	}

	return; #return if no key was found
};

1;
