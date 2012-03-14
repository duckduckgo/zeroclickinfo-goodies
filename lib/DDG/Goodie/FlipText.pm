package DDG::Goodie::FlipText;

use DDG::Goodie;

triggers startend => "flip";

zci is_cached => 1;

handle remainder => sub {
	my @string = split(//, $_);
	my $flippedString = "";

	foreach $char (@string) {
		$flippedString .= "\x{0250}" if $char eq "a";
	}

	return $flippedString;
};
