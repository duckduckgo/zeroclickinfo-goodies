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
    github => [ 'jdorweiler', 'Jason_Dorweiler'];

zci answer_type => 'Latex';

my %texCommands = (

	#Math operators
	"and" => ['logical AND', '\land', '$A \land B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"or" =>  ['logical OR', '\lor', '$A \lor B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"not" => ['logical NOT', '\neg', '$\neg B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"union" => ['union', '\cap', '$A \cap B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"intersection" => ['intersection', '\cup', '$A \cup B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"implication" => ['implication', '\rightarrow', '$A \rightarrow B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"iff" => ['if and only if', '\leftrightarrow', '$A \leftrightarrow B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"if and only if" => ['if and only if', '\leftrightarrow', '$A \leftrightarrow B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"subset" => ['subset or subset equal', '\subset or \subseteq', '$A \subset B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
        "less than or equal" => ['logical less than or equal', '\leq', '$A \leq B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"less than" => ['logical less than', '<' , '$A < B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Symbols'],
        "<=" => ['logical less than or equal', '\leq', '$A \leq B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Symbols'],
	"<" => ['logical less than', '<' , '$A < B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Symbols'],
	"greater than or equal" => ['logical greater than or equal', '\geq', '$A \geq B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"greater than" => ['logical greater than', '>' , '$A > B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Symbols'],
	">=" => ['logical greater than or equal', '\geq', '$A \geq B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	">" => ['logical greater than', '>' , '$A > B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Symbols'],

	#math functions
	"sum" => ['summation', '\sum_{lower}^{upper}', '$\sum{i=0}^{10} x^{2}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Sums_and_integrals'],
	"summation" => ['summation', '\sum_{lower}^{upper}', '$\sum{i=0}^{10} x^{2}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Sums_and_integrals'],
	"fraction" => ['fraction', '\frac{numerator}{denominator}', '$\frac{A}{B}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Fractions_and_Binomials'],
	"limit" => ['limit', '\lim{bound}', '$\lim{x \to +\infty} 2x^{2}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Operators'],
	"integral" => ['integral', '\int_lowerbound^upperbound', '$\int_a^b f(x)dx$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Sums_and_integrals'],
	"square root" => ['square root', '\sqrt[n][x]', '$\sqrt[n][x]$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Roots'],

	#math symbols
	"infinity" => ['infinity', '\infty', '$\infty$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Operators'],
	"dot" => ['center dots', '\cdot or \cdots', '$A+ \cdots +B$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Dots'],
	"alpha" => ['alpha', '\alpha', '$\alpha$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"delta" => ['delta', '\delta (lower casee) or \Delta (upper case)', '$\delta$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"zeta" => ['zeta', '\zeta', '$\zeta$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"lambda" => ['lambda', '\lambda (lower case) or \Lambda (upper case)', '$\lambda$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"xi" => ['xi', '\xi (lower case) or \Xi (upper case)', '$\xi$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"sigma" => ['sigma', '\sigma (lower case) or \Sigma (upper case)', '$\sigma$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"phi" => ['phi', '\phi (lower case) or \Phi (upper case)', '$\phi$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"omega" => ['omega', '\omega (lower case) or \Omega (upper case)', '$\omega$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],
	"theta" => ['theta', '\theta (lower case) or \Theta (upper case)', '$\theta$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Greek_letters'],

	#other
	"date" => ['date', '\today', '\today', 'https://en.wikibooks.org/wiki/LaTeX/Document_Structure#Top_matter'],
	"new line" => ['new line', '\\', 'text... \\', 'https://en.wikibooks.org/wiki/LaTeX/Paragraph_Formatting#Manual_breaks'],
	"subscript" => ['subscript', '_{x}', '$H_{2}O$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Powers_and_indices'],
	"superscript" => ['superscript', '^{x}', '$x^{2}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#Powers_and_indices'],
	"temperature" => ['temperature', '^{\circ}', '$25^{circ}\mathrm{c}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"temp" => ['temperature', '^{\circ}', '$25^{circ}\mathrm{c}$', 'https://en.wikibooks.org/wiki/LaTeX/Mathematics#List_of_Mathematical_Symbols'],
	"line" => ['horizontal line', '\hrulefill', '\hrulefill', 'https://en.wikibooks.org/wiki/LaTeX/Lengths#Fill_the_rest_of_the_line'],
);

sub more_at {
    return "<br><a href='$_[0]'>More at Wikibooks</a>";
}

sub build_html {
	# builds a string to display using the given $command
	# and $usage
	return "<i>LaTeX command:</i> <pre style='display: inline; padding: 1px;'>$_[0]</pre> <br> <i>Example:</i> <pre style='display: inline; padding: 1px'>$_[1]</pre>" . more_at($_[2]);
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
