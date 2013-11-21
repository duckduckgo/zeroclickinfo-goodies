package DDG::Goodie::Latex;
# ABSTRACT: Shows the latex command and example usage for a keyword.

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
    "and" => 'logical AND, Command: \land Usage: $A \land B$',
    "or" => 'logical OR, Command: \lor Usage: $A \lor B$',
    "not" => 'logical NOT, Command: \neg Usage: $\neg B$',
    "sum" => 'summation, Command: \sum_{lower}^{upper} Usage: $\sum{i=0}^{10} x^{2}$',
    "summation" => 'summation, Command: \sum_{lower}^{upper} Usage: $\sum{i=0}^{10} x^{2}$',
    "less than or equal" => 'logical less than or equal, Command: \leq Usage: $A \leq B$',  
    "less than" => 'logical less than Command: <, Usage: $A < B$',
    "union" => 'union, Command: \cap Usage: $A \cap B$',
    "intersection" => 'intersection, Command: \cup Usage: $A \cup B$',
    "implication" => 'implication, Command: \rightarrow Usage: $A \rightarrow B$',
    "iff" => 'if and only if, Command: \leftrightarrow Usage: $A \leftrightarrow B$',
    "if and only if" => 'if and only if, Command: \leftrightarrow Usage: $A \leftrightarrow B$',
    "fraction" => 'fraction, Command: \frac{numerator}{denominator} Usage: $\frac{A}{B}$',
    "limit" => 'limit, Command: \lim{bounds} Usage: $\lim{x \to +\infty} 2x^{2}$',
    "infinity" => 'infinity, Command: \infty Usage: $\infty$',
    "integral" => 'integral, Command: \int_lowerbound^upperbound Usage: $\int_a^b f(x)dx$',
);

handle remainder => sub {
	my $key= lc $_; #set key to lower case
	my $command = $texCommands{$key}; #get tex command from hash
	return "Latex $command" if $command;
	return;
};

1;
