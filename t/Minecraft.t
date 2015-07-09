#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;
use URI::Escape;

zci answer_type => 'minecraft';
zci is_cached   => 1;

ddg_goodie_test(
    [
        'DDG::Goodie::Minecraft'
    ],

    'ladder crafting minecraft' =>
    test_zci(
        'Minecraft Ladder ingredients: Sticks.',
        make_structured_answer(
            "Ladder",
            "Sticks",
            "Used for climbing walls. You can climb either horizontally or vertically. To climb safely, you can sneak while climbing (hold shift).",
            "http://www.minecraftxl.com/images/wiki/recipes/ladder-crafting.png",
        )
    ),

    'tnt minecraft' =>
    test_zci(
        'Minecraft TNT ingredients: Gunpowder + Sand.',
        make_structured_answer(
            "TNT",
            "Gunpowder + Sand",
            "When activated, TNT creates an explosion that damages nearby block and creatures.",
            "http://www.minecraftxl.com/images/wiki/recipes/tnt-crafting.png",
        )
    ),

    'minecraft how to craft a book' =>
    test_zci(
        'Minecraft Book ingredients: Paper + Leather.',
        make_structured_answer(
            "Book",
            "Paper + Leather",
            "Used to create book and quills, bookshelfs or an enchantment table.",
            "http://www.minecraftxl.com/images/wiki/recipes/book-crafting.png",
        )
    ),

    'minecraft activator rail' =>
    test_zci(
        'Minecraft Activator Rail ingredients: Iron Ingots + Sticks + Redstone Torch.',
        make_structured_answer(
            "Activator Rail",
            "Iron Ingots + Sticks + Redstone Torch",
            "Used to activate TNT Minecarts or Minecarts with Hoppers.",
            "http://www.minecraftxl.com/images/wiki/recipes/activator-rail-crafting.png",
        )
    ),

    'how do i craft an anvil in minecraft' =>
    test_zci(
        'Minecraft Anvil ingredients: Iron Blocks + Iron Ingots.',
        make_structured_answer(
            "Anvil",
            "Iron Blocks + Iron Ingots",
            "Used to combine enchantments and repair and rename items or blocks. Anvils are affected by gravity.",
            "http://www.minecraftxl.com/images/wiki/recipes/anvil-crafting.png",
        )
    ),

    'craft ladder' => undef,
    'make tnt' => undef,
    'burger minecraft' => undef,
    'crafting burgers in minecraft' => undef,
    'how do i craft a cheeseburger in minecraft' => undef,
    'minecraft download' => undef,
    'cool texture packs for minecraft' => undef,
);

sub make_structured_answer {
    my ($name, $ingredients, $description, $image ) = @_;
    my %recipe = (
        name => $name,
        ingredients => $ingredients,
        description => $description,
        image => $image
    );

    return structured_answer => {
        id => 'minecraft',
        name => 'Minecraft',
        data => {
            title => $recipe{'name'},
            subtitle => "Ingredients: " . $recipe{'ingredients'},
            description => $recipe{'description'},
            image => 'https://duckduckgo.com/iu/?u=' . uri_escape( $recipe{'image'} )
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

done_testing;
