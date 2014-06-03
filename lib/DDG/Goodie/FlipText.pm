package DDG::Goodie::FlipText;

use DDG::Goodie;

triggers startend => "flip text", "mirror text", "spin text", "rotate text";

zci is_cached => 1;
zci answer_type => "flip_text";

primary_example_queries 'flip text sentence';
secondary_example_queries 'mirror text hello';
description 'flip and mirror text';
name 'FlipText';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/FlipText.pm';
category 'transformations';
topics 'words_and_games';
attribution web => [ 'robert.io', 'Robert Picard' ],
            github => [ 'http://github.com/rpicard', 'rpicard'],
            twitter => ['http://twitter.com/__rlp', '__rlp'];

my %charMap = (
	"a" => "\x{0250}",
	"b" => "q",
	"c" => "\x{0254}",
	"d" => "p",
	"e" => "\x{01DD}",
	"f" => "\x{025F}",
	"g" => "\x{0183}",
	"h" => "\x{0265}",
	"i" => "\x{0131}",
	"j" => "\x{027E}",
	"k" => "\x{029E}",
	"l" => "l",
	"m" => "\x{026F}",
	"n" => "u",
	"o" => "o",
	"p" => "d",
	"q" => "b",
	"r" => "\x{0279}",
	"s" => "s",
	"t" => "\x{0287}",
	"u" => "n",
	"v" => "\x{028C}",
	"w" => "\x{028D}",
	"x" => "x",
	"y" => "\x{028E}",
	"z" => "z",
	"A" => "\x{2200}",
	"B" => "B",
	"C" => "\x{0186}",
	"D" => "D",
	"E" => "\x{018E}",
	"F" => "\x{2132}",
	"G" => "\x{05E4}",
	"H" => "H",
	"I" => "I",
	"J" => "\x{017F}",
	"K" => "K",
	"L" => "\x{02E5}",
	"M" => "W",
	"N" => "N",
	"O" => "O",
	"P" => "\x{0500}",
	"Q" => "Q",
	"R" => "R",
	"S" => "S",
	"T" => "\x{2534}",
	"U" => "\x{2229}",
	"V" => "\x{039B}",
	"W" => "M",
	"X" => "X",
	"Y" => "\x{2144}",
	"Z" => "Z",
	"0" => "0",
	"1" => "\x{0196}",
#	"2" => "\x{1105}", Doesn't display in tests
	"3" => "\x{0190}",
#	"4" => "\x{3123}", Doesn't display in tests
#	"5" => "\x{03DB}", Doesn't really look like a 5
	"6" => "9",
#	"7" => "\x{3125}", Doesn't display in tests
	"8" => "8",
	"9" => "6",
	"," => "'",
	"." => "\x{02D9}",
	"?" => "\x{00BF}",
	"!" => "\x{00A1}",
	'"' => ",,",
	"'" => ",",
	"`" => ",",
	"(" => ")",
	")" => "(",
	"[" => "]",
	"]" => "[",
	"{" => "}",
	"}" => "{",
	">" => "<",
	"<" => ">",
	"_" => "\x{203E}");

handle remainder => sub {

    my %reverseCharMap = reverse %charMap;
	my @string = split(//, reverse $_);
	my $flippedString; 

	for (@string) {

		# Not all uppercase letters can be flipped
		$_ = lc;

		if ( exists $charMap{$_}) {
			$flippedString .= $charMap{$_};
		} elsif (exists $reverseCharMap{$_}) {
            $flippedString .= $reverseCharMap{$_};
        } else {
			$flippedString .= $_;
		}
	}

	

	return $flippedString;
};

1;
