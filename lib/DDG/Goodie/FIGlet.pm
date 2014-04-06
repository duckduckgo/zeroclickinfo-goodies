package DDG::Goodie::FIGlet;
# ABSTRACT: Uses FIGlet to make large letters out of ordinary text.

use DDG::Goodie;
use Text::FIGlet;

triggers startend => "figlet", "bigtext";
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

	if ($font) {
		return Text::FIGlet->new(-f=>$font, -d=>share())->figify(-w=>$width, -A=>$text);
	} else {
		return Text::FIGlet->new(-d=>share())->figify(-w=>$width, -A=>$text);
	}
}

# Apply CSS.
sub apply_css {
	my ($html) = @_;
	my $css = share("style.css")->slurp;
	return "<style type='text/css'>$css</style>\n" . $html;
}

handle query => sub {
	my $font;
	my $text;
	my $figlet;
	my $html;
	my $heading;

	# Return if no input provided.
	return if (($_ eq 'figlet') || ($_ eq 'bigtext'));

	# Parse query.
	$_ =~ m/^(?:figlet|bigtext)(?:\-|\s+)(.*)|(.*)\s+(?:figlet|bigtext)$/;
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
	$heading = $text . " (FIGlet)";
	$html = "<div id='figlet-wrapper'><span>Font: <pre>$font</pre></span><pre>$figlet</pre></div>";

	return $figlet, html => apply_css($html), heading => $heading if $figlet;
	return;
};

1;
