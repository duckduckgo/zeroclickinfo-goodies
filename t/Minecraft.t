#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'minecraft';
zci is_cached   => 1;

ddg_goodie_test(
    [
        'DDG::Goodie::Minecraft'
    ],
    'ladder crafting minecraft' =>
    test_zci(
        'Minecraft Ladder ingredients: Sticks.',
        html => '<div id="minecraft-wrapper"><h3>Ladder</h3><div id="minecraft-recipe" style="float: left; width: 50%;"><p>Used for climbing walls. You can climb either horizontally or vertically. To climb safely, you can sneak while climbing (hold shift).</p><p>Ingredients: Sticks</p></div><div id="minecraft-recipe-image" style="float: right; width: 40%;"><img src="https://duckduckgo.com/iu/?u=http%3A%2F%2Fwww.minecraftxl.com%2Fimages%2Fwiki%2Frecipes%2Fladder-crafting.png" /></div></div>'
    ),
    'tnt minecraft' =>
    test_zci(
        'Minecraft TNT ingredients: Gunpowder + Sand.',
        html => '<div id="minecraft-wrapper"><h3>TNT</h3><div id="minecraft-recipe" style="float: left; width: 50%;"><p>When activated, TNT creates an explosion that damages nearby block and creatures.</p><p>Ingredients: Gunpowder + Sand</p></div><div id="minecraft-recipe-image" style="float: right; width: 40%;"><img src="https://duckduckgo.com/iu/?u=http%3A%2F%2Fwww.minecraftxl.com%2Fimages%2Fwiki%2Frecipes%2Ftnt-crafting.png" /></div></div>'
    ),
    'minecraft how to craft a book' =>
    test_zci(
        'Minecraft Book ingredients: Paper + Leather.',
        html => '<div id="minecraft-wrapper"><h3>Book</h3><div id="minecraft-recipe" style="float: left; width: 50%;"><p>Used to create book and quills, bookshelfs or an enchantment table.</p><p>Ingredients: Paper + Leather</p></div><div id="minecraft-recipe-image" style="float: right; width: 40%;"><img src="https://duckduckgo.com/iu/?u=http%3A%2F%2Fwww.minecraftxl.com%2Fimages%2Fwiki%2Frecipes%2Fbook-crafting.png" /></div></div>'
    ),
    'minecraft activator rail' =>
    test_zci(
        'Minecraft Activator Rail ingredients: Iron Ingots + Sticks + Redstone Torch.',
        html => '<div id="minecraft-wrapper"><h3>Activator Rail</h3><div id="minecraft-recipe" style="float: left; width: 50%;"><p>Used to activate TNT Minecarts or Minecarts with Hoppers.</p><p>Ingredients: Iron Ingots + Sticks + Redstone Torch</p></div><div id="minecraft-recipe-image" style="float: right; width: 40%;"><img src="https://duckduckgo.com/iu/?u=http%3A%2F%2Fwww.minecraftxl.com%2Fimages%2Fwiki%2Frecipes%2Factivator-rail-crafting.png" /></div></div>'
    ),
    'how do i craft an anvil in minecraft' =>
    test_zci(
        'Minecraft Anvil ingredients: Iron Blocks + Iron Ingots.',
        html => '<div id="minecraft-wrapper"><h3>Anvil</h3><div id="minecraft-recipe" style="float: left; width: 50%;"><p>Used to combine enchantments and repair and rename items or blocks. Anvils are affected by gravity.</p><p>Ingredients: Iron Blocks + Iron Ingots</p></div><div id="minecraft-recipe-image" style="float: right; width: 40%;"><img src="https://duckduckgo.com/iu/?u=http%3A%2F%2Fwww.minecraftxl.com%2Fimages%2Fwiki%2Frecipes%2Fanvil-crafting.png" /></div></div>'
    ),

    'craft ladder' => undef,
    'make tnt' => undef,  
    'burger minecraft' => undef,
    'crafting burgers in minecraft' => undef,
    'how do i craft a cheeseburger in minecraft' => undef,
    'minecraft download' => undef,
    'cool texture packs for minecraft' => undef,
);

done_testing;
