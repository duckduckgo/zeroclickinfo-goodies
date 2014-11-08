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
        html => '<div id="minecraft-wrapper"><h3>Ladder</h3><span>Used for climbing walls. You can climb either horizontally or vertically. To climb safely, you can sneak while climbing (hold shift).</span><img src="https://duckduckgo.com/iu/?u=http%3A%2F%2Fwww.minecraftxl.com%2Fimages%2Fwiki%2Frecipes%2Fladder-crafting.png" style="display: block; margin: 0.5em 0;" /><span>Ingredients: Sticks</span></div>'
    ),
    'tnt minecraft' =>
    test_zci(
        'Minecraft TNT ingredients: Gunpowder + Sand.',
        html => '<div id="minecraft-wrapper"><h3>TNT</h3><span>When activated, TNT creates an explosion that damages nearby block and creatures.</span><img src="https://duckduckgo.com/iu/?u=http%3A%2F%2Fwww.minecraftxl.com%2Fimages%2Fwiki%2Frecipes%2Ftnt-crafting.png" style="display: block; margin: 0.5em 0;" /><span>Ingredients: Gunpowder + Sand</span></div>'
    ),
    'minecraft how to craft a book' =>
    test_zci(
        'Minecraft Book ingredients: Paper + Leather.',
        html => '<div id="minecraft-wrapper"><h3>Book</h3><span>Used to create book and quills, bookshelfs or an enchantment table.</span><img src="https://duckduckgo.com/iu/?u=http%3A%2F%2Fwww.minecraftxl.com%2Fimages%2Fwiki%2Frecipes%2Fbook-crafting.png" style="display: block; margin: 0.5em 0;" /><span>Ingredients: Paper + Leather</span></div>'
    ),
    'minecraft activator rail' =>
    test_zci(
        'Minecraft Activator Rail ingredients: Iron Ingots + Sticks + Redstone Torch.',
        html => '<div id="minecraft-wrapper"><h3>Activator Rail</h3><span>Used to activate TNT Minecarts or Minecarts with Hoppers.</span><img src="https://duckduckgo.com/iu/?u=http%3A%2F%2Fwww.minecraftxl.com%2Fimages%2Fwiki%2Frecipes%2Factivator-rail-crafting.png" style="display: block; margin: 0.5em 0;" /><span>Ingredients: Iron Ingots + Sticks + Redstone Torch</span></div>'
    ),
    'how do i craft an anvil in minecraft' =>
    test_zci(
        'Minecraft Anvil ingredients: Iron Blocks + Iron Ingots.',
        html => '<div id="minecraft-wrapper"><h3>Anvil</h3><span>Used to combine enchantments and repair and rename items or blocks. Anvils are affected by gravity.</span><img src="https://duckduckgo.com/iu/?u=http%3A%2F%2Fwww.minecraftxl.com%2Fimages%2Fwiki%2Frecipes%2Fanvil-crafting.png" style="display: block; margin: 0.5em 0;" /><span>Ingredients: Iron Blocks + Iron Ingots</span></div>'
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
