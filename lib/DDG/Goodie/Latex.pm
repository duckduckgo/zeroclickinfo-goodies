package DDG::Goodie::Latex;
# ABSTRACT: Show the Latex command for a keyword

use DDG::Goodie;

triggers startend => 'latex', 'tex';
primary_example_queries 'latex summation';
description 'Show the Latex command for a keyword';
category 'cheat_sheets';
topics 'programming', 'math','special_interest';
name 'Latex';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Latex.pm';
attribution
    web => ['www.transistor.io', 'Jason Dorweiler'],
    github => [ 'jdorweiler', 'Jason Dorweiler'];

zci answer_type => 'Latex';
zci is_cached   => 1;

my %texCommands = (

	#Math operators
	"and" => ['Logical AND', '\land', '$A \land B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"or" =>  ['Logical OR', '\lor', '$A \lor B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"not" => ['Logical NOT', '\neg', '$\neg B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"union" => ['Union', '\cap', '$A \cap B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"intersection" => ['Intersection', '\cup', '$A \cup B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"implication" => ['Implication', '\rightarrow', '$A \rightarrow B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"iff" => ['If and Only If', '\leftrightarrow', '$A \leftrightarrow B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"if and only if" => ['If and Only If', '\leftrightarrow', '$A \leftrightarrow B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"subset" => ['Subset or Subset Equal', '\subset or \subseteq', '$A \subset B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
        "less than or equal" => ['Logical Less Than or Equal', '\leq', '$A \leq B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"less than" => ['Logical Less Than', '<' , '$A < B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Symbols'],
        "<=" => ['Logical Less Than or Equal', '\leq', '$A \leq B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Symbols'],
	"<" => ['Logical Less Than', '<' , '$A < B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Symbols'],
	"greater than or equal" => ['Logical Greater Than or Equal', '\geq', '$A \geq B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"greater than" => ['Logical Greater Than', '>' , '$A > B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Symbols'],
	">=" => ['Logical Greater Than or Equal', '\geq', '$A \geq B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	">" => ['Logical Greater Than', '>' , '$A > B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Symbols'],

	#math functions
	"sum" => ['Summation', '\sum_{lower}^{upper}', '$\sum{i=0}^{10} x^{2}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Sums_and_integrals'],
	"summation" => ['Summation', '\sum_{lower}^{upper}', '$\sum{i=0}^{10} x^{2}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Sums_and_integrals'],
	"fraction" => ['Fraction', '\frac{numerator}{denominator}', '$\frac{A}{B}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Fractions_and_Binomials'],
	"limit" => ['Limit', '\lim{bound}', '$\lim{x \to +\infty} 2x^{2}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Operators'],
	"integral" => ['Integral', '\int_lowerbound^upperbound', '$\int_a^b f(x)dx$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Sums_and_integrals'],
	"square root" => ['Square Root', '\sqrt[n][x]', '$\sqrt[n][x]$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Roots'],

	#math symbols
	"infinity" => ['Infinity', '\infty', '$\infty$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Operators'],
	"dot" => ['Center Dots', '\cdot or \cdots', '$A+ \cdots +B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Dots'],
	"alpha" => ['Alpha', '\alpha', '$\alpha$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"delta" => ['Delta', '\delta (lowercase) or \Delta (uppercase)', '$\delta$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"zeta" => ['Zeta', '\zeta', '$\zeta$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"lambda" => ['Lambda', '\lambda (lowercase) or \Lambda (uppercase)', '$\lambda$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"xi" => ['Xi', '\xi (lowercase) or \Xi (uppercase)', '$\xi$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"sigma" => ['Sigma', '\sigma (lowercase) or \Sigma (uppercase)', '$\sigma$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"phi" => ['Phi', '\phi (lowercase) or \Phi (uppercase)', '$\phi$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"omega" => ['Omega', '\omega (lowercase) or \Omega (uppercase)', '$\omega$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"theta" => ['Theta', '\theta (lowercase) or \Theta (uppercase)', '$\theta$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],

	#other
	"date" => ['Date', '\today', '\today', 'https://en.wikibooks.org/wiki/LaTeX/Document_Structure#Top_matter'],
	"new line" => ['Newline', '\\', 'text... \\', 'https://en.wikibooks.org/wiki/LaTeX/Paragraph_Formatting#Manual_breaks'],
	"subscript" => ['Subscript', '_{x}', '$H_{2}O$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Powers_and_indices'],
	"superscript" => ['Superscript', '^{x}', '$x^{2}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Powers_and_indices'],
	"temperature" => ['Temperature', '^{\circ}', '$25^{circ}\mathrm{c}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"temp" => ['Temperature', '^{\circ}', '$25^{circ}\mathrm{c}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"line" => ['Horizontal Line', '\hrulefill', '\hrulefill', 'https://en.wikibooks.org/wiki/LaTeX/Lengths#Fill_the_rest_of_the_line'],
);

sub more_at {
    return "<a href='$_[0]' class='zci__more-at--info'>More at Wikibooks</a>";
}

sub build_html {
	# builds a string to display using the given $command
	# and $usage
	return "<div><span class='latex--key'>LaTeX command:</span> <pre class='latex--value'>$_[0]</pre></div><div><span class='latex--key'>Example:</span> <pre class='latex--value'>$_[1]</pre></div>" . more_at($_[2]);
}

handle remainder => sub {
	my $key = lc $_; #set key to lower case
	my $command = $texCommands{$key}[1]; #get tex command from hash

	if($command) { #check to see if the key was in the table
                my $heading = $texCommands{$key}[0];
                my $usage = $texCommands{$key}[2];
		my $more = $texCommands{$key}[3];
		my $text = "LaTeX command: $command\nExample: $usage";

        	#build the html string to display
        	my $html = build_html($command, $usage, $more);

                return $text, html => $html, heading => "$heading (LaTeX)";
	}
	return; #return if no key was found
};

1;
