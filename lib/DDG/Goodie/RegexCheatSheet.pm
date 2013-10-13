#!/bin/env perl
package DDG::Goodie::RegexCheatSheet;
# ABSTRACT: Provide a cheatsheet for common Regular Expression syntax
use strict;
use warnings;

use HTML::Entities;
use DDG::Goodie;

zci answer_type => "regex_cheat";

triggers start =>	"regex cheatsheet", "regex cheat sheet", "regex help", 
					"regexp cheatsheet", "regexp cheat sheet", "regexp help",
					"regex symbols", "regex symbol",
					"regexp symbols", "regexp symbol",
					"regex chars", "regex char",
					"regexp chars", "regexp char",
					"regex characters", "regex character",
					"regexp characters", "regexp character", 
					"regex", "regular expressions",
					"regular expression";

triggers end => "regex";

attribution github => ['https://github.com/mintsoft', 'mintsoft'];
primary_example_queries 'regex';
secondary_example_queries 'regexp $';
category 'computing_tools';

# The order to display each category and in which columns
our @category_column = (
	['Anchors', 'Character Classes', 'POSIX Classes', 'Pattern Modifiers', 'Escape Sequences'],
	['Quantifiers', 'Groups and Ranges', 'Assertions', 'Special Characters', 'String Replacement']
);

# Titles of tables and the symbols to explain
our %categories = (
	'Anchors' => [
		'^', '\A', '$', '\Z', '\b', '\B', '\<' , '\>'
	],
	'Character Classes' => [
		'\c', '\s', '\S', '\d', '\D', '\w', '\W', '\x', '\O'
	],
	'POSIX Classes' => [
		'[:upper:]', '[:lower:]', '[:alpha:]', '[:alnum:]', '[:digit:]',
		'[:xdigit:]', '[:punct:]', '[:blank:]', '[:space:]', '[:cntrl:]',
		'[:graph:]', '[:print:]', '[:word:]'
	],
	'Assertions' => [
		'?=', '?!', '?<=', '?!= or ?<!', '?>', '?()', '?()|', '?#'
	],
	'Quantifiers' => [
		'*', '+', '?', '{3}', '{3,}', '{2,5}'
	],
	'Escape Sequences' => [
		'\\', '\Q', '\E'
	],
	'Special Characters' => [
		'\n', '\r', '\t', '\v', '\f', '\ooo', '\xhh'
	],
	'Groups and Ranges' => [
		'.', '(a|b)', '(...)', '(?:...)', '[abc]', '[^abc]', '[a-q]', '[A-Z]', '[0-9]'
	],
	'Pattern Modifiers' => [
		'//g', '//i', '//m', '//s', '//x', '//e', '//U'
	],
	'String Replacement' => [
		'$n', '$2', '$1', '$`', q{$'}, '$+', '$&'
	],
);

# Symbols and their explanation/description
our %syntax_map = (
	'.'	=>	'Any character except newline (\n)',
	'(a|b)'	=>	'a or b',
	'(...)'	=>	'Group',
	'(?:...)'	=>	'Passive (non-capturing) group',
	'[abc]'	=>	'Single character (a or b or c)',
	'[^abc]'	=>	'Single character (not a or b or c)',
	'[a-q]'	=>	'Single character range (a or b ... or q)',
	'[A-Z]'	=>	'Single character range (A or B ... or Z)',
	'[0-9]'	=>	'Single digit from 0 to 9',
	'^'	=>	"Start of string or line",	
	'\A'	=>	"Start of string",
	'$'	=>	"End of string or line",
	'\Z'	=>	"End of string",
	'\b'	=>	'Word boundary',
	'\B'	=>	'Not word boundary',
	'\<'	=>	'Start of word',
	'\>'	=>	'End of word',
	'\c'	=> 	'Control character',
	'\s'	=>	'Whitespace',
	'\S'	=>	'Not Whitespace',
	'\d'	=>	'Digit',
	'\D'	=>	'Not digit',
	'\w'	=>	'Word',
	'\W'	=>	'Not Word',
	'\x'	=>	'Hexadecimal digit',
	'\O'	=>	'Octal Digit',
	'[:upper:]'	=>	'Uppercase letters [A-Z]',
	'[:lower:]'	=>	'Lowercase letters [a-z]',
	'[:alpha:]'	=>	'All letters [A-Za-z]',
	'[:alnum:]'	=>	'Digits and letters [A-Za-z0-9]',
	'[:digit:]'	=>	'Digits [0-9]',
	'[:xdigit:]'	=>	'Hexadecimal digits [0-9a-f]',
#	'[:punct:]'	=>	'Punctuation [\]\[!"#$%&'."'".'()*+,./:;<=>?@\^_`{|}~-]',
	'[:punct:]'	=>	'Punctuation',
	'[:blank:]'	=>	'Space and tab [ \t]',
	'[:space:]'	=>	'Blank characters [ \t\r\n\v\f]',
	'[:cntrl:]'	=>	'Control characters [\x00-\x1F\x7F]',
	'[:graph:]'	=>	'Printed characters [\x21-\x7E]',
	'[:print:]'	=>	'Printed characters and spaces 	[\x20-\x7E]',
	'[:word:]'	=>	'Digits, letters and underscore [A-Za-z0-9_]',
	'?='	=>	'Lookahead assertion',
	'?!'	=>	'Negative lookahead',
	'?<='	=>	'Lookbehind assertion',
	'?!= or ?<!'	=>	'Negative lookbehind',
	'?>'	=>	'Once-only Subexpression',
	'?()'	=>	'Condition [if then]',
	'?()|'	=>	'Condition [if then else]',
	'?#'	=>	'Comment',
	'*'	=>	'0 or more',
	'+'	=>	'1 or more',
	'?'	=>	'0 or 1 (optional)',
	'{3}'	=>	'Exactly 3',
	'{3,}'	=>	'3 or more',
	'{2,5}'	=>	'2, 3, 4 or 5',
	'\\'	=>	'Escape following character',
	'\Q'	=>	'Begin literal sequence',
	'\E'	=>	'End literal sequence',
	'\n'	=>	'New line',
	'\r'	=>	'Carriage return',
	'\t'	=>	'Tab',
	'\v'	=>	'Vertical tab',
	'\f'	=>	'Form feed',
	'\ooo'	=>	'Octal character ooo',
	'\xhh'	=>	'Hex character hh',
	'//g'	=>	'Global Match (all occurrences)',
	'//i'	=>	'Case-insensitive',
	'//m'	=>	'Multiple line',
	'//s'	=>	'Treat string as single line',
	'//x'	=>	'Allow comments and whitespace',
	'//e'	=>	'Evaluate replacement',
	'//U'	=>	'Ungreedy pattern',
	'$n'	=>	'n-th non-passive group',
	'$2'	=>	'"xyz" in /^(abc(xyz))$/',
	'$1'	=>	'"xyz" in /^(?:abc)(xyz)$/',
	'$`'	=>	'Before matched string',
	q{$'}	=>	'After matched string',
	'$+'	=>	'Last matched string',
	'$&'	=>	'Entire matched string',
);

handle remainder => sub {
		
	#if the user has requested information on a specific thing 
	if (length $_ > 0) 
	{
		my $syntax_key = $_;
		#let the user provide a number for {3}
		if ($_ =~ /\{([0-9]+)\}/)
		{
			return "$_ - Exactly $1 occurrences", html => "<code> " . encode_entities($_) . " </code> - Exactly " .  encode_entities($_) . " occurrences";
		}
		#let the user provide numbers for {3,} and {3,5}
		elsif ($_ =~ /\{([0-9]+),([0-9]+)?\}/)
		{
			if ($2) {
				return unless ($1 < $2);
				return "$_ - Between $1 and $2 occurrences", html => "<code> " . encode_entities($_) . " </code> - Between $1 and $2 occurrences";
			}
			return "$_ - $1 or more", html =>  "<code> " . encode_entities($_) . " </code> - $1 or more occurrences";
		}

		return unless $syntax_map{$syntax_key};
		my $text_output = "$_ - $syntax_map{$syntax_key}";
		my $html_output = "<code> " . encode_entities($_) . " </code> - " . encode_entities($syntax_map{$syntax_key});
		return $text_output, html => $html_output;
	}
	
	#otherwise display the complete tabular output, into n columns in the order specified
	
	my $text_output = '';
	
	#style assigned to the outside wrapper div (around all content)
	my $div_wrapper_style = 'max-height: 45ex; overflow-y: scroll; overflow-x: hidden';
	
	#style assigned to the wrapper column divs
	my $div_column_style = 'width: 48%; display: inline-block; vertical-align: top;';
	
	#style assigned to each table of results (Anchors, Quantifiers etc)
	my $table_style = 'width: 100%; margin-bottom: 1ex;';
		
	#content of the div column wrapper 
	my @html_columns = ();
	
	for(my $column = 0; $column < scalar(@category_column); ++$column) 
	{
		for my $category ( @{$category_column[$column]} )
		{
			my $new_table = "<table style='$table_style'>
								<caption><b> $category </b></caption>";
			
			$text_output .= "$category\n";
			
			for my $syntax_object ( @{$categories{$category}} ) 
			{
				$new_table .= "	<tr>
									<td><code> " . encode_entities($syntax_object) . " </code></td>
									<td> " . encode_entities($syntax_map{$syntax_object}) . " </td>
								</tr>" . "\n";

				$text_output .= "\t$syntax_object - $syntax_map{$syntax_object} \n";
			}
			
			$text_output .= "\n";                 
			$new_table .= "</table>" . "\n";
			
			$html_columns[$column] .= "\n" . $new_table;
		}
	}
	
	my $html_output = "<div style='$div_wrapper_style'><div style='$div_column_style'>";
	$html_output .= join ("</div><div style='$div_column_style'>", @html_columns);
	$html_output .= "</div></div>";
	return $text_output, html => $html_output;
};

1;