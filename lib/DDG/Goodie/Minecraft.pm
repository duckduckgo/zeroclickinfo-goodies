package DDG::Goodie::Minecraft;
# ABSTRACT: Minecraft crafting recipes.

use DDG::Goodie;
use JSON;

triggers start => "minecraft crafting", "minecraft craft", "minecrafting", "minecraft make";
triggers end => "crafting minecraft", "craft minecraft", "in minecraft";

primary_example_queries 'minecraft crafting tnt';
secondary_example_queries 'tnt craft minecraft';

name 'Minecraft';
description 'Minecraft crafting recipes.';
category 'special';
topics 'words_and_games';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Minecraft.pm';
attribution
	web => ['http://engvik.nu', 'Lars Jansøn Engvik'],
	github => [ 'larseng', 'Lars Jansøn Engvik'];

zci answer_type => 'minecraft';
zci is_cached => 1;

# Fetch recipes.
my $json = share('crafting-guide.json')->slurp;
my $decoded = decode_json($json);
my @recipes = @{ $decoded->{'items'} };

# Creates the HTML.
sub make_html {
	my ($recipe) = @_;
	my $html = '';

	$html = '<div id="minecraft-wrapper">';
	$html .= '<h3>' . $recipe->{'name'} . '</h3>';
	$html .= '<span>' . $recipe->{'description'} . '</span>';
	$html .= '<img src="' . $recipe->{'image'} . '" style="display: block; margin: 0.5em 0;" />';
	$html .= '<span>Ingredients: ' . $recipe->{'ingredients'} . '</span>';
	$html .= '</div>';

	return $html;
}

handle remainder => sub {

	# Look for a recipe and make an answer if we found it.
	foreach my $r ( @recipes ) {
		if (lc $r->{'name'} eq lc $_) {
			my $plain = $r->{'name'} . ' are made from ' . $r->{'ingredients'} . '.';
			my $html = make_html($r);
			return $plain, html => $html;
		}
	}

	return;
};
1;
