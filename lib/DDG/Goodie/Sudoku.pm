package DDG::Goodie::Sudoku;
# ABSTRACT: Show a small sudoku puzzle.

use DDG::Goodie;
use Games::Sudoku::Component;

use strict;
use warnings;

triggers start => 'sudoku';
triggers end => 'sudoku';
triggers start => "i'm bored";
triggers start => 'i am bored';
triggers start => 'this is boring';

zci is_cached => 0;
zci answer_type => "sudoku";

primary_example_queries 'sudoku easy';
secondary_example_queries 'I am bored';
description 'show a little sudoku you can play in the browser';
name 'Sudoku';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Sudoku.pm';
category 'random';
attribution github => ['https://github.com/DrDub', 'DrDub'],
            web => ['http://duboue.net/', 'Pablo Duboue'];

handle remainder => sub {
	my($difficulty) = m/^((average)|(medium)|(hard))?$/;
	$difficulty = "easy" unless ($difficulty);

    if(/bored|boring/i){
        $difficulty = "hard"; 
    }
    
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

	my $html_table = "";
	for my $line (@sudoku_lines)
	{
		my @chars = split(/ /, $line);
		for my $char (@chars) 
		{
			$char = "<input maxlength='1'/>" if $char eq "_";
		}
		
		$html_table .= "<tr><td>" . join("</td><td>", @chars) . "</td></tr>\n";
	}
	my $stylesheet = scalar share("style.css")->slurp;
	my $html_output = "<style type='text/css'>$stylesheet</style> \n<table class='sudoku'>\n" . $html_table . "</table>";
	return $str_output, html => $html_output;
};

1;