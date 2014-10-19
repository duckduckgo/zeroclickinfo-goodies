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
            'Ladder are made from Sticks.',
            html => '<div id="minecraft-wrapper"><h3>Ladder</h3><span>Used for climbing walls. You can climb either horizontally or vertically. To climb safely, you can sneak while climbing (hold shift).</span><img src="http://www.minecraftxl.com/images/wiki/recipes/ladder-crafting.png" style="display: block; margin: 0.5em 0;" /><span>Ingredients: Sticks</span></div>'
        ),
	'tnt in minecraft' =>
		test_zci(
			'TNT are made from Gunpowder + Sand.',
			html => '<div id="minecraft-wrapper"><h3>TNT</h3><span>When activated, TNT creates an explosion that damages nearby block and creatures.</span><img src="http://www.minecraftxl.com/images/wiki/recipes/tnt-crafting.png" style="display: block; margin: 0.5em 0;" /><span>Ingredients: Gunpowder + Sand</span></div>'
		),
	'minecraft crafting book' =>
		test_zci(
			'Book are made from Paper + Leather.',
			html => '<div id="minecraft-wrapper"><h3>Book</h3><span>Used to create book and quills, bookshelfs or an enchantment table.</span><img src="http://www.minecraftxl.com/images/wiki/recipes/book-crafting.png" style="display: block; margin: 0.5em 0;" /><span>Ingredients: Paper + Leather</span></div>'
		),
    'minecraft craft activator rail' =>
		test_zci(
			'Activator Rail are made from Iron Ingots + Sticks + Redstone Torch.',
			html => '<div id="minecraft-wrapper"><h3>Activator Rail</h3><span>Used to activate TNT Minecarts or Minecarts with Hoppers.</span><img src="http://www.minecraftxl.com/images/wiki/recipes/activator-rail-crafting.png" style="display: block; margin: 0.5em 0;" /><span>Ingredients: Iron Ingots + Sticks + Redstone Torch</span></div>'
		),
	'craft ladder' => undef,
    'make tnt' => undef,  
);

done_testing;
