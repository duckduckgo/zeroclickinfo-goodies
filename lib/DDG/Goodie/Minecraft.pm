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

# Create a hash with good words.
sub populate_good_words() {
    my @good_words;

    foreach my $recipe (keys %recipes) {
        if ($recipe !~ /\s/) {
            push (@good_words, $recipe);
        } else {
            my @words = split /\s+/, $recipe;
            push (@good_words, @words);
        }
    }

    return map { $_ => 1 } @good_words;
}

my %bad_words = qw(download server tutorial mod mods skins skin texture pack packs project projects);
my %good_words = populate_good_words();
my $okay_words = qr/\b\s*crafting\s*\b|\b\s*a\s*\b/i;

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
    my @query = split /\s+/, lc $_; # Split on whitespaces.
    my $lookup = '';

    # Loop through the query.
    foreach (@query) {
        return if(exists($bad_words{$_})); # Not looking for a recipe.
        $lookup .= $_ . ' ' if(exists($good_words{$_})); # Words exists in a recipe, add it.
    }

    chop $lookup; # Remove trailing whitespace.

    my $recipe = $recipes{$lookup}; # Check if this actually is a recipe.

    # No recipe found, let's try again without the okay words.
    if (!$recipe) {
        $lookup =~ s/$okay_words//g;
        $recipe = $recipes{$lookup};
        return unless $recipe; # Definitely not a recipe.
    }

    # Recipe found, let's return an answer.
    my $plain = $recipe->{'name'} . ' are made from ' . $recipe->{'ingredients'} . '.';
    my $html = make_html($recipe);

    return $plain, html => $html;
    return;
};
1;
