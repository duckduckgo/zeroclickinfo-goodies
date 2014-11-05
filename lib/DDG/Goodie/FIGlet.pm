package DDG::Goodie::FIGlet;
# ABSTRACT: Uses FIGlet to make large letters out of ordinary text.

use utf8;
use DDG::Goodie;
use Text::FIGlet;

triggers startend => "figlet", "bigtext", "big text";
primary_example_queries 'figlet DuckDuckGo';
secondary_example_queries 'figlet computer DuckDuckGo';

name 'FIGlet';
description 'Uses FIGlet to make large letters out of ordinary text.';
category 'transformations';
topics 'words_and_games';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Figlet.pm';
attribution
	web => ['http://engvik.nu', 'Lars Jansøn Engvik'],
	github => [ 'larseng', 'Lars Jansøn Engvik'];

zci answer_type => 'figlet';
zci is_cached => 1;

my $width = 800;

# Fetch available fonts.
opendir DIR, share();
my @fonts = readdir(DIR);
closedir DIR;

# Renders a figlet.
sub render_figlet {
	my ($font, $text) = @_;
	return Text::FIGlet->new(-f=>$font, -d=>share())->figify(-w=>$width, -A=>$text);
}

handle query => sub {
	my $font;
	my $text;
	my $figlet;
	my $html;

	# Return if no input provided.
	return if ((lc $_ eq 'figlet') || (lc $_ eq 'bigtext') || (lc $_ eq 'big text'));

	# Parse query.
	$_ =~ m/^(?:figlet|bigtext|big text)(?:\-|\s+)(.*)|(.*)\s+(?:figlet|bigtext|big text)$/i;
	$text = $1 if $1;
	$text = $2 if $2;

	# Checks if the first word is a font.
	$text =~ m/^\s*(\w+)/;
	$font = lc $1 if grep /\b$1\b/i, @fonts;

	# Strip the font from the text to render if we're using a font.
	if ($font && $font ne $text) {
		$text = substr $text, length ($font)+1, length $text;
	} else {
		$font = "standard";
	}

	# Render the FIGlet
	$figlet = render_figlet($font, $text);

	$html = "<div id='figlet-wrapper'><span>Font: </span><span id='figlet-font'>$font</span><pre contenteditable='true'>$figlet</pre></div>";

	return $figlet, html => $html if $figlet;
	return;
};

1;
