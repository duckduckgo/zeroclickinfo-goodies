package DDG::Goodie::Minecraft;
# ABSTRACT: Minecraft crafting recipes.

use DDG::Goodie;
use JSON;

triggers startend => "minecraft";

primary_example_queries 'cake minecraft';
secondary_example_queries 'how do i craft a cake in minecraft';

name 'Minecraft';
description 'Minecraft crafting recipes.';
source 'http://thejool.com/api/crafting-guide.json';
category 'special';
topics 'words_and_games';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Minecraft.pm';
attribution
    web => ['http://engvik.nu', 'Lars Jansøn Engvik'],
    github => [ 'larseng', 'Lars Jansøn Engvik'];

zci answer_type => 'minecraft';
zci is_cached => 1;

# Fetch and store recipes in a hash.
my $json = share('crafting-guide.json')->slurp;
my $decoded = decode_json($json);
my %recipes = map{ lc $_->{'name'} => $_ } (@{ $decoded->{'items'} });

my $strip_words = qr/\b\s*crafting\s*\b|\b\s*craft\s*\b|\b\s*make\s*\b|\b\s*how\s*\b|\b\s*do\s*\b|\b\s*to\s*\b|\b\s*in\s*\b|\b\s*an\s*\b|\b\s*a\s*\b|\b\s*i\s*\b/i;

# Creates the HTML.
sub make_html {
    my ($recipe) = @_;
    my $html = '';

    $html = '<div id="minecraft-wrapper">';
    $html .= '<h3>' . $recipe->{'name'} . '</h3>';
    $html .= '<span>' . $recipe->{'description'} . '</span>';
    $html .= '<img src="https://duckduckgo.com/iu/?u=' . $recipe->{'image'} . '" style="display: block; margin: 0.5em 0;" />';
    $html .= '<span>Ingredients: ' . $recipe->{'ingredients'} . '</span>';
    $html .= '</div>';

    return $html;
}

handle remainder => sub {
    # Strip words we want to strip and return if what's left is not a recipe.
    $_ =~ s/$strip_words//g;
    my $recipe = $recipes{lc $_};
    return unless $recipe;

    my $plain = $recipe->{'name'} . ' are made from ' . $recipe->{'ingredients'} . '.';
    my $html = make_html($recipe);

    return $plain, html => $html;
    return;
};
1;
