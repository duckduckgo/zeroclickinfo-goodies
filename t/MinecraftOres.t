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

    'ironore minecraft' =>
    test_zci(
        'Minecraft Iron Ore.',
        make_structured_answer(
            "Iron Ore",
            "Mineral block that drops coal when mined",
            "Generated naturally in veins between stone blocks, much like other ores. Coal veins can vary greatly in size — mountaintop deposits are usually five blocks at most, but underground ones are generally at least ten blocks, and can range up to 64. Coal ore is also found in small amounts alongside underground fossils.",
            "/share/goodie/minecraftOres/$goodieVersion/images/coal-ore.png",
        )
    ),
    'minecraft diamondores' =>
    test_zci(
        'Minecraft Crafting Table ingredients: Wooden Plank.',
        make_structured_answer(
            "Crafting Table",
            "Wooden Plank",
            "When placed on the ground, it provides use of the 3×3 crafting grid.",
            "http://www.minecraftxl.com/images/wiki/recipes/crafting-table-crafting.png",
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
    my ($name, $subtitle, $description, $image) = @_;
    my %ore = (
	    name => $name,
        subtitle => $subtitle,
        description => $description,
        image = $image
    );

    return structured_answer => {
        data => {
                title => $ore{'name'},
                #url => "https://minecraft.gamepedia.com/"  . uri_esc( $ore->{'name'} ), # Not the best way
                subtitle => $ore{'sub'},
                description => $ore{'description'}
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