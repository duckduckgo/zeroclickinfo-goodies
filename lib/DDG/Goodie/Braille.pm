package DDG::Goodie::Braille;
# ABSTRACT: Converts a string into Unicode Braille.

use DDG::Goodie;
use utf8;

attribution github => ['https://github.com/teamnigel', 'teamnigel'];
primary_example_queries 'braille DuckDuckGo is awesome!';
description 'Changes a text string into Unicode Braille';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Braille.pm';
name 'Braille';
category 'words_and_games';
topics 'language';

triggers start => 'braille';

zci is_cached => 1;

handle remainder => sub {
	
	my $result;
	my $curChar;
	if ($_) {
		my $length = length $_;
		for my $pos (0 .. $length) {
			my $curChar = substr $_, $pos, 1;
			if ($curChar eq ',') { $result .= "⠂"; }
			if ($curChar eq ';') { $result .= "⠆"; }
			if ($curChar eq ':') { $result .= "⠒"; }
			if ($curChar eq '.') { $result .= "⠲"; }
			if ($curChar eq '!') { $result .= "⠖"; }
			if ($curChar eq '(') { $result .= "⠶"; }
			if ($curChar eq ')') { $result .= "⠶"; }
			if ($curChar eq '?') { $result .= "⠦"; }
			if ($curChar eq '*') { $result .= "⠔⠔"; }
			if ($curChar eq '†') { $result .= "⠔⠔"; }
			if ($curChar eq '‡') { $result .= "⠔⠔"; }
			if ($curChar eq '¶') { $result .= "⠔⠔"; }
			if ($curChar eq '/') { $result .= "⠌"; }
			if ($curChar eq '-') { $result .= "⠤"; }
			if ($curChar eq '—') { $result .= "⠤⠤⠤"; }
			if (uc $curChar eq $curChar ) { $result .= "⠠"; }
			if (uc $curChar eq "A") { $result .= "⠁"; }
			if (uc $curChar eq "B") { $result .= "⠃"; }
			if (uc $curChar eq "C") { $result .= "⠉"; }
			if (uc $curChar eq "D") { $result .= "⠙"; }
			if (uc $curChar eq "E") { $result .= "⠑"; }
			if (uc $curChar eq "F") { $result .= "⠋"; }
			if (uc $curChar eq "G") { $result .= "⠛"; }
			if (uc $curChar eq "H") { $result .= "⠓"; }
			if (uc $curChar eq "I") { $result .= "⠊"; } 
			if (uc $curChar eq "J") { $result .= "⠚"; } 
			if (uc $curChar eq "K") { $result .= "⠅"; }
			if (uc $curChar eq "L") { $result .= "⠇"; }
			if (uc $curChar eq "M") { $result .= "⠍"; }
			if (uc $curChar eq "N") { $result .= "⠝"; }
			if (uc $curChar eq "O") { $result .= "⠕"; }
			if (uc $curChar eq "P") { $result .= "⠏"; }
			if (uc $curChar eq "Q") { $result .= "⠟"; }
			if (uc $curChar eq "R") { $result .= "⠗"; }
			if (uc $curChar eq "S") { $result .= "⠎"; }
			if (uc $curChar eq "T") { $result .= "⠞"; }
			if (uc $curChar eq "U") { $result .= "⠥"; }
			if (uc $curChar eq "V") { $result .= "⠧"; }
			if (uc $curChar eq "W") { $result .= "⠺"; }
			if (uc $curChar eq "X") { $result .= "⠭"; }
			if (uc $curChar eq "Y") { $result .= "⠽"; }
			if (uc $curChar eq "Z") { $result .= "⠵"; }
			if (uc $curChar eq "0") { $result .= "⠼⠚"; }
			if (uc $curChar eq "1") { $result .= "⠼⠁"; }
			if (uc $curChar eq "2") { $result .= "⠼⠃"; }
			if (uc $curChar eq "3") { $result .= "⠼⠉"; }
			if (uc $curChar eq "4") { $result .= "⠼⠙"; }
			if (uc $curChar eq "5") { $result .= "⠼⠑"; }
			if (uc $curChar eq "6") { $result .= "⠼⠋"; }
			if (uc $curChar eq "7") { $result .= "⠼⠛"; }
			if (uc $curChar eq "8") { $result .= "⠼⠓"; }
			if (uc $curChar eq "9") { $result .= "⠼⠊"; }
			if ($curChar eq " ") { $result .= " "; }
		}
	} else {
		return;
	}
	return $result;
};

1;
