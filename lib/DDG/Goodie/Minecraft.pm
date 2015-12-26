package DDG::Goodie::Minecraft;
# ABSTRACT: Minecraft crafting recipes.

use strict;
use DDG::Goodie;
use JSON;

zci answer_type => 'minecraft';
zci is_cached => 1;

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

triggers startend => "minecraft";

# Fetch and store recipes in a hash.
my $json = share('crafting-guide.json')->slurp;
my $decoded = decode_json($json);
my %recipes = map{ lc $_->{'name'} => $_ } (@{ $decoded->{'items'} });

# Good words: All the words that recipe names consist of.
# Okay words: Words that could be a part of the query, but not part of a recipe.
# Bad words: Words related to Minecraft, but not related to recipes.
my %good_words = map { $_ => 1 } map { split /\s+/ } (keys %recipes);
my %bad_words  = map { $_ => 1 } (qw(download server tutorial mod mods skins skin texture pack packs project projects));
my @okay_words = ('a','an','in','crafting','recipe','how to make','how to craft','how do I make','how do I craft');

handle remainder => sub {
	my $remainder = $_;
	# remove the ok words (or phrases)
	foreach my $ok_word (@okay_words) {
		$remainder =~ s/\b$ok_word\b//gi;
	}
	$remainder =~ s/(^\s*|\s*$)//; # trim leading/trailing whitespace
    my @query = split /\s+/, lc $remainder; # Split on whitespaces.
    my @lookup;
    my @unhandled;

    # Loop through the query.
    foreach (@query) {
        return if(exists($bad_words{$_})); # Not looking for a recipe.
        if (exists($good_words{$_})) {
        	push (@lookup, $_); # Word exists in a recipe, add it.
        } else {
        	push (@unhandled, $_); # otherwise word is not part of recipe, add it to unhandled
        }
    }
	return if scalar(@unhandled);

    my $recipe = $recipes{join(' ', @lookup)};
    return unless $recipe;

    # Recipe found, let's return an answer.
    my $plaintext = 'Minecraft ' . $recipe->{'name'} . ' ingredients: ' . $recipe->{'ingredients'} . '.';

    return $plaintext,
    structured_answer => {
        id => 'minecraft',
        name => 'Minecraft',
        data => {
            title => $recipe->{'name'},
            subtitle => "Ingredients: " . $recipe->{'ingredients'},
            description => $recipe->{'description'},
            image => 'https://duckduckgo.com/iu/?u=' . uri_esc( $recipe->{'image'} )
        },
        meta => {
            sourceName => "Minecraft Wiki",
            sourceUrl => "http://minecraft.gamepedia.com/Crafting#Complete_recipe_list"
        },
        templates => {
            group => 'info',
            options => {
                moreAt => 1
            }
        }
    };
};

1;
