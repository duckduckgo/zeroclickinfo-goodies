#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use DDG::Test::Goodie;
use URI::Escape;

zci answer_type => 'minecraft ores';
zci is_cached   => 1;

my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

ddg_goodie_test(
    [
        'DDG::Goodie::MinecraftOres'
    ],

    'iron ore minecraft' =>
    test_zci(
        'Minecraft Iron Ore.',
        make_structured_answer(
            "Iron Ore",
            "Mineral block found underground. It is the most common mineral that can be used to make tools and armor",
            "Veins can vary in size, but the most common is 2×2×2. Iron always comes in veins of 4 to 10 unless dirt, gravel, a cave, or another ore overlapped into it. Each block in the vein, which otherwise would be stone, has a random chance of being iron ore instead.",
            "iron-ore.png",
            "5-54",
#           "0-64",
#           "65-67",
            "68",
            "Stone",
            "The Overworld",
            "Solid Block",
            "15",
            "3",
            "0",
            "0.7",
            "Itself",
            "Classic 0.0.14a_01"
        )
    ),
    'minecraft diamond ores' =>
    test_zci(
        'Minecraft Diamond Ore.',
        make_structured_answer(
            "Diamond Ore",
            "Mineral block that is one of the most valuable and elusive blocks in the game",
            "Can be found in veins of 1-10. One diamond ore vein generates per chunk; this vein or part of it may be overwritten by generated structures such as caves, leaving you without any diamonds in said chunk. Also, because of the way chunks are populated the vein belonging to a chunk can actually be generated in a neighboring chunk leading to some chunks with two or more veins and others with foundupto. In some vein formations, ores connect diagonally. Therefore it is recommended to mine around diamond ore. This also permits checking for lava.",
            "diamond-ore.png",
            "5-12",
#            "0-12",
#            "13-15",
            "16",
            "Iron",
            "The Overworld",
            "Solid Block",
            "15",
            "3",
            "0",
            "1",
            "Itself",
            "Classic 0.0.14a_01"
        )
    ),

    'craft ladder' => undef,
    'make tnt' => undef,
    'burger minecraft' => undef,
    'crafting burgers in minecraft' => undef,
    'how do i craft a cheeseburger in minecraft' => undef,
    'minecraft download' => undef,
    'cool texture packs for minecraft' => undef,
    'minecraft cake design' => undef,
    'minecraft ruby ore' => undef
);

sub make_structured_answer {
    my ($name, $subtitle, $description, $imageName, $best, $foundupto, $minTier, $found, $type, $blastresistance, $hardness, $expmined, $expsmelted, $drop, $firstappearance) = @_;
    my %ore = (
	    name => $name,
        subtitle => $subtitle,
        description => $description,
        imageName => $imageName,
        best => $best,
#        common => $common,
#        rare = $rare,
        foundupto => $foundupto,
        minTier => $minTier,
        found => $found,
        type => $type,
        blastresistance => $blastresistance,
        hardness => $hardness,
        expmined => $expmined,
        expsmelted => $expsmelted,
        drop => $drop,
        firstappearance => $firstappearance
    );
    return structured_answer => {
        data => {
                title => $ore{'name'},
                url => "https://minecraft.gamepedia.com/"  . uri_escape($name) . uri_escape("_Ore"), # Not the best way
                subtitle => $ore{'subtitle'},
                description => $ore{'description'},
                image => "/share/goodie/minecraft_ores/$goodieVersion/images/$imageName",
                infoboxData => [
                    {
                        heading => "Ore specifications"
                    },
                    {
                        label => "Best Layers:",
                        value => $ore{'best'},
                        url => "https://minecraft.gamepedia.com/Ore#Availability"
                    },
#                    {
#                        label => "Common in Layers:",
#                        value => $ore{'common'}
#                    },
#                    {
#                        label => "rare in layers:",
#                        value => $ore{'rare'}
#                    },
                    {
                        label => "Found up to Layer:",
                        value => $ore{'foundupto'},
                        url => "https://minecraft.gamepedia.com/Ore#Availability"
                    },
                    {
                        label => "Minimum Pickaxe Tier:",
                        value => $ore{'minTier'},
                        url => "https://minecraft.gamepedia.com/Pickaxe#Mining"
                    },
                    {
                        label => "Found in",
                        value => $ore{'found'},
                        url => "https://minecraft.gamepedia.com/Dimensions"
                    },
                    {
                        heading => "General"
                    },
                    {
                        label => "Type:",
                        value => $ore{'type'}
                    },
                    {
                        label => "Blast Resistance Level:",
                        value => $ore{'blastresistance'},
                        url => "https://minecraft.gamepedia.com/Explosion#Blast_resistance"
                    },
                    {
                        label => "Hardness Level:",
                        value => $ore{'hardness'},
                        url => "https://minecraft.gamepedia.com/Breaking#Blocks_by_hardness"
                    },
                    {
                        label => "Experience obtained when Mined:",
                        value => $ore{'expmined'},
                        url => "https://minecraft.gamepedia.com/Experience#Experience_amounts_by_source"
                    },
                    {
                        label => "Experience obtained when Smelted:",
                        value => $ore{'expsmelted'},
                        url => "https://minecraft.gamepedia.com/Experience#Experience_amounts_by_source"
                    },
                    {
                        label => "Drop:",
                        value => $ore{'drop'},
                        url => "https://minecraft.gamepedia.com/Drops"
                    },
                    {
                        label => "First Appearance:",
                        value => $ore{'firstappearance'},
                        url => "https://minecraft.gamepedia.com/Version_history"
                    }
                ]
            },
            meta => {
                sourceName => "Minecraft Wiki",
                sourceUrl => "https://minecraft.gamepedia.com/Ore#Availability"
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