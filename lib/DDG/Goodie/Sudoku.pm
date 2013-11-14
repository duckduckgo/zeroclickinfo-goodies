package DDG::Goodie::Sudoku;
# ABSTRACT: Show a small sudoku puzzle.

use DDG::Goodie;
use Games::Sudoku::Component;

use strict;
use warnings;

triggers start => 'sudoku';
triggers start => 'i\'m bored';
triggers start => 'i am bored';
triggers start => 'this is boring';

zci is_cached => 0;
zci answer_type => "sudoku";

primary_example_queries 'sudoku 4x4 easy';
secondary_example_queries 'I am bored';
description 'show a little sudoku you can play in the browser';
name 'Sudoku';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Sudoku.pm';
category 'random';
attribution github => ['https://github.com/DrDub', 'DrDub'],
            web => ['http://duboue.net/', 'Pablo Duboue'];

handle query => sub {
	my($number, $difficulty) = m/^sudoku ([49])?(?:x[49])?\s*((easy)|(medium)|(hard))?$/;
	$number = 9 unless ($number);
	$difficulty = "easy" unless ($difficulty);

    if(/bored|boring/i){
        $number = 9;
        $difficulty = "hard"; 
    }
    
    my $sudoku = Games::Sudoku::Component->new(size=>$number);
    my $blanks = 0.25;
    if ($difficulty eq "hard")
    {
        $blanks = 0.75;
    } 
    elsif($difficulty eq "medium")
    {
        $blanks = 0.5;
    }

    $sudoku->generate(blanks => ($number ** 2) * $blanks);
	my $str_output = $sudoku->as_string(separator => " ", linebreak => "\n");
	
	#switch 0 to more sensible placeholders
	$str_output =~ s/0/_/g;
	
	my @sudoku_lines = split(/\n/, $str_output);

	my $html_table = "";
	for my $line (@sudoku_lines)
	{
		my @chars = split(/ /, $line);
		for my $char (@chars) 
		{
			$char = "<input length='1'/>" if $char eq "_";
		}
		
		$html_table .= "<tr><td>" . join("</td><td>", @chars) . "</td></tr>\n";
	}
	my $inline_style = "
	table.sudoku td {
		width: 1.5em;
		height: 1.5em;
		text-align: center;
		vertical-align: middle;
		border: 1px solid rgba(230,230,230,1);
	}
	table.sudoku tr:nth-of-type(3) td, table.sudoku tr:nth-of-type(6) td
	{
		border-bottom: 2px solid rgba(200,200,200,1);
	}
	table.sudoku td:nth-of-type(3), table.sudoku td:nth-of-type(6)
	{
		border-right: 2px solid rgba(200,200,200,1);
	}
	table.sudoku input {
		border: 0px;
		width: 1em;
	}
	";
	my $html_output = "<style>" . $inline_style . "</style><table class='sudoku'>\n" . $html_table . "</table>";
	return $str_output, html => $html_output;
};

1;