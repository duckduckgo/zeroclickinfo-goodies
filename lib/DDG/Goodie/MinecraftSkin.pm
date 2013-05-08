package DDG::Goodie::MinecraftSkin;

use DDG::Goodie;

primary_example_queries 'minecraft skin teamnigel';
secondary_example_queries 'minotar teamnigel';
description 'show the Minecraft skin for a given username (case sensitive!)';
name 'Minecraft Skin';
#code_url '';
category 'reference';
topics 'gaming';

#attribution github => [''];

triggers any => "minecraft skin", "minotar", "minecraftskin";

zci is_cached => 1;
zci answer_type => "minecraft skin";

handle remainder => sub {
	return if ($_ =~ m/[^a-zA-Z0-9]/);
	return $_, html => '<img src="https://minotar.net/avatar/' . $_ . '/64.png"> <img src="https://minotar.net/skin/' . $_ . '">';
	return;
};

1;
