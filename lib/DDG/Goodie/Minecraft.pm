package DDG::Goodie::Minecraft;
# ABSTRACT: Minecraft crafting recipes.

use DDG::Goodie;
use JSON;
use utf8;
use URI::Escape::XS;

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

# Good words: All the words that recipe names consist of.
# Okay words: Words that are in the good words list, but also could be a part of the query.
# Bad words: Words related to Minecraft, but not related to recipes.
my %good_words = map { $_ => 1 } map { split /\s+/ } (keys %recipes);
my %okay_words = map { $_ => 1 } (qw(a crafting));
my %bad_words = map { $_ => 1 } (qw(download server tutorial mod mods skins skin texture pack packs project projects));

# Creates the HTML.
sub make_html {
    my ($recipe) = @_;
    my $html = '';
    my $uri = 'https://duckduckgo.com/iu/?u=' . encodeURIComponent($recipe->{'image'});

    $html = '<div id="minecraft-wrapper">';
    $html .= '<h3>' . $recipe->{'name'} . '</h3>';
    $html .= '<div id="minecraft-recipe" style="float: left; width: 50%;">';
    $html .= '<p>' . $recipe->{'description'} . '</p>';
    $html .= '<p>Ingredients: ' . $recipe->{'ingredients'} . '</p>';
    $html .= '</div>';
    $html .= '<div id="minecraft-recipe-image" style="float: right; width: 40%;">';
    $html .= '<img src="' . $uri . '" />';
    $html .= '</div>';
    $html .= '</div>';

    return $html;
}

handle remainder => sub {
    my @query = split /\s+/, lc $_; # Split on whitespaces.
    my @lookup;

    # Loop through the query.
    foreach (@query) {
        return if(exists($bad_words{$_})); # Not looking for a recipe.
        push (@lookup, $_) if(exists($good_words{$_})); # Word exists in a recipe, add it.
    }

    my $recipe = $recipes{join(' ', @lookup)} || $recipes{join(' ', grep { !$okay_words{$_} } @lookup)};
    return unless $recipe;

    # Recipe found, let's return an answer.
    my $plain = 'Minecraft ' . $recipe->{'name'} . ' ingredients: ' . $recipe->{'ingredients'} . '.';
    my $html = make_html($recipe);

    return $plain, html => $html;
};
1;
