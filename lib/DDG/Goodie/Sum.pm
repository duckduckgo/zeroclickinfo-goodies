package DDG::Goodie::Sum;
# ABSTRACT: Sum of all natural numbers from X to Y (X and Y included)

use DDG::Goodie;


zci answer_type => 'sum';
zci is_cached => 1;

#Attribution
primary_example_queries "sum from 1 to 1000", "sum from 50 to 5000";
secondary_example_queries "optional -- demonstrate any additional triggers";
description "Sum of all natural numbers from X to Y (X and Y included)";
name "Sum";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Sum.pm";
category 'calculations';
topics 'math';

attribution github => ["https://github.com/navneet35371", "navneet35371"],
            twitter => ["https://twitter.com/navneet35371", "navneet35371"],
            email => [ 'mailto:navneet35371@gmail.com', 'navneet35371' ];

# Triggers
triggers any => "sum";

# Handle statement
handle remainder => sub {
	my $ans = 0;
	$_ =~ m/(\d+)\s*+[a-zA-Z-]*\s*(\d+)/;
	
	$ans = ((($2 * ($2 + 1)) / 2)-(($1 * ($1 - 1)) / 2)); 
	
	return "Sum from natural number $1 to $2 is = $ans",html => "Sum from natural number <b>$1</b> to <b>$2</b> is = <b>$ans</b>\n";

};

1;
