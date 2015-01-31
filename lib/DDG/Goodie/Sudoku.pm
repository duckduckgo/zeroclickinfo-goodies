package DDG::Goodie::Sudoku;
# ABSTRACT: Show a small sudoku puzzle.

use DDG::Goodie;
use Games::Sudoku::Component;

use strict;
use warnings;

triggers startend => 'sudoku';

zci is_cached => 0;
zci answer_type => "sudoku";

primary_example_queries 'sudoku easy';
description 'show a little sudoku you can play in the browser';

name 'Sudoku';
category 'random';
attribution github => ['DrDub', 'Pablo Duboue'],
	web => ['http://duboue.net/', 'Pablo Duboue'],
	github => ['https://github.com/mintsoft', 'Rob Emery'];

sub parse_to_html_table(@)
{
	my @sudoku_lines = @_;
	my $html_table = "<table class='sudoku'>\n";
	for my $line (@sudoku_lines)
	{
		my @chars = split(/ /, $line);
		for my $char (@chars)
		{
			$char = "<input maxlength='1'/>" if $char eq "_";
		}
		$html_table .= "<tr><td>" . join("</td><td>", @chars) . "</td></tr>\n";
	}
	$html_table .= "</table>";
	return $html_table;
}

handle remainder => sub {

	return unless /^(easy|average|medium|hard|random|generate|play|)$/;

	my($difficulty) = m/^(average|medium|hard)?$/;
	$difficulty = "easy" unless ($difficulty);

	my $sudoku = Games::Sudoku::Component->new(size => 9);

	#proportion of the grid to be blank
	my $blanks = 0.25;
	$blanks = 0.75 if ($difficulty eq "hard");
	$blanks = 0.5 if ($difficulty eq "medium" || $difficulty eq "average");

	$sudoku->generate(blanks => (9 ** 2) * $blanks);
	my $str_output = $sudoku->as_string();

	#switch 0 to more sensible placeholders
	$str_output =~ s/0/_/g;

	my @sudoku_lines = split(/\n/, $str_output);
	my $html_table = parse_to_html_table(@sudoku_lines);

	return $str_output, html => $html_table;
};

1;
