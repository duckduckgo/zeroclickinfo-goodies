#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use DDG::Test::Goodie;
use URI::Escape;

zci answer_type => 'minecraft';
zci is_cached   => 1;

my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

ddg_goodie_test(
    [
        'DDG::Goodie::Minecraft'
    ],

    'ladder crafting minecraft' =>
    test_zci(
        'Minecraft Ladder ingredients: 7 Stick.',
        make_structured_answer(
            "Ladder",
            "7 Stick",
            "Used for climbing walls. You can climb either horizontally or vertically. To climb safely, you can sneak while climbing (hold shift).",
            "http://www.minecraftxl.com/images/wiki/recipes/ladder-crafting.png",
        )
    ),
    'how to make a ladder crafting minecraft' =>
    test_zci(
        'Minecraft Ladder ingredients: 7 Stick.',
        make_structured_answer(
            "Ladder",
            "7 Stick",
            "Used for climbing walls. You can climb either horizontally or vertically. To climb safely, you can sneak while climbing (hold shift).",
            "http://www.minecraftxl.com/images/wiki/recipes/ladder-crafting.png",
        )
    ),
    'crafting table minecraft' =>
    test_zci(
        'Minecraft Crafting Table ingredients: 4 Wood Planks.',
        make_structured_answer(
            "Crafting Table",
            "4 Wood Planks",
            "When placed on the ground, it provides use of the 3×3 crafting grid.",
            "/share/goodie/minecraft/$goodieVersion/images/crafting-table.gif",
        )
    ),
    
    'how do I craft a workbench in minecraft' =>
    test_zci(
        'Minecraft Crafting Table ingredients: 4 Wood Planks.',
        make_structured_answer(
            "Crafting Table",
            "4 Wood Planks",
            "When placed on the ground, it provides use of the 3×3 crafting grid.",
            "/share/goodie/minecraft/$goodieVersion/images/crafting-table.gif",
        )
    ),

    'how to make a crafting table minecraft' =>
    test_zci(
        'Minecraft Crafting Table ingredients: 4 Wood Planks.',
        make_structured_answer(
            "Crafting Table",
            "4 Wood Planks",
            "When placed on the ground, it provides use of the 3×3 crafting grid.",
            "/share/goodie/minecraft/$goodieVersion/images/crafting-table.gif",
        )
    ),

    'tnt minecraft' =>
    test_zci(
        'Minecraft TNT ingredients: 5 Gunpowder + 4 Sand.',
        make_structured_answer(
            "TNT",
            "5 Gunpowder + 4 Sand",
            "An explosive block. When activated, it creates an explosion that damages nearby creatures and destroys nearby blocks",
            "http://www.minecraftxl.com/images/wiki/recipes/tnt-crafting.png",
        )
    ),

    'minecraft how to craft a book' =>
    test_zci(
        'Minecraft Book ingredients: 3 Paper + 1 Leather.',
        make_structured_answer(
            "Book",
            "3 Paper + 1 Leather",
            "Used to create book and quills, bookshelfs or an enchantment table. Can be enchanted.",
            "http://www.minecraftxl.com/images/wiki/recipes/book-crafting.png",
        )
    ),

    'minecraft activator rail' =>
    test_zci(
        'Minecraft Activator Rail ingredients: 6 Iron Ingot + 2 Stick + 1 Redstone Torch.',
        make_structured_answer(
            "Activator Rail",
            "6 Iron Ingot + 2 Stick + 1 Redstone Torch",
            "Used to activate TNT Minecarts or Minecarts with Hoppers.",
            "http://www.minecraftxl.com/images/wiki/recipes/activator-rail-crafting.png",
        )
    ),

    'how do i craft an anvil in minecraft' =>
    test_zci(
        'Minecraft Anvil ingredients: 3 Iron Block + 4 Iron Ingot.',
        make_structured_answer(
            "Anvil",
            "3 Iron Block + 4 Iron Ingot",
            "Used to combine enchantments, repair or rename items or blocks. Anvils are affected by gravity. On average, an anvil will survive for 25 uses.",
            "http://www.minecraftxl.com/images/wiki/recipes/anvil-crafting.png",
        )
    ),

    'recipe for a shovel on minecraft' =>
    test_zci(
        'Minecraft Shovel ingredients: 2 Stick + 1 Wood Planks OR 1 Cobblestone OR 1 Iron Ingot OR 1 Gold Ingot OR 1 Diamond.',
        make_structured_answer(
            "Shovel",
            "2 Stick + 1 Wood Planks OR 1 Cobblestone OR 1 Iron Ingot OR 1 Gold Ingot OR 1 Diamond",
            "Used to effectively dig sand, dirt, gravel, snow and clay. Required to dig snowballs.",
            "http://www.minecraftxl.com/images/wiki/recipes/shovels-crafting.gif",
        )
    ),

    'minecraft make colored hard clay' =>
    test_zci(
        'Minecraft Colored Terracotta ingredients: 8 Terracotta + 1 Dye.'
,
        make_structured_answer(
            "Colored Terracotta",
            "8 Terracotta + 1 Dye",
            "Used as decoration or building material.",
            "/share/goodie/minecraft/999/images/colored-terracotta.gif",
        )
    ),

    # Same as last but with british spelling of colour
    'minecraft make coloured hard clay' =>
    test_zci(
        'Minecraft Colored Terracotta ingredients: 8 Terracotta + 1 Dye.'
,
        make_structured_answer(
            "Colored Terracotta",
            "8 Terracotta + 1 Dye",
            "Used as decoration or building material.",
            "/share/goodie/minecraft/999/images/colored-terracotta.gif",
        )
    ),

    'diamond shovel' => undef,
    'craft ladder' => undef,
    'make tnt' => undef,
    'burger minecraft' => undef,
    'crafting burgers in minecraft' => undef,
    'how do i craft a cheeseburger in minecraft' => undef,
    'minecraft download' => undef,
    'cool texture packs for minecraft' => undef,
    'minecraft cake design' => undef,
    'minecraft cake guide' => undef,
);

sub make_structured_answer {
    my ($name, $ingredients, $description, $image ) = @_;
    my %recipe = (
        name => $name,
        ingredients => $ingredients,
        description => $description,
        image => $image,
        imageTile => 1
    );

    return structured_answer => {
        data => {
            title => $recipe{'name'},
            subtitle => "Ingredients: " . $recipe{'ingredients'},
            description => $recipe{'description'},
            image => $recipe{'image'},
            imageTile => 1
        },
         meta => {
            sourceName => "Minecraft Wiki",
            sourceUrl => 'http://minecraft.gamepedia.com/'  . uri_escape( $recipe{'name'} )
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
