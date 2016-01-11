package DDG::Goodie::Minecraft;
# ABSTRACT: Minecraft crafting recipes.

use strict;
use DDG::Goodie;
use JSON;

zci answer_type => 'minecraft';
zci is_cached => 1;

triggers startend => "minecraft";

# Fetch and store recipes in a hash.
my $json = share('crafting-guide.json')->slurp;
my $decoded = decode_json($json);
my %recipes = map{ lc $_->{'name'} => $_ } (@{ $decoded->{'items'} });

# Good words: All the words that recipe names consist of.
# Okay words: Words that are in the good words list, but also could be a part of the query.
# Bad words: Words related to Minecraft, but not related to recipes.
my %good_words = map { $_ => 1 } map { split /\s+/ } (keys %recipes);
my %okay_words = map { $_ => 1 } (qw(a crafting));
my %bad_words  = map { $_ => 1 } (qw(download server tutorial mod mods skins skin texture pack packs project projects));

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
