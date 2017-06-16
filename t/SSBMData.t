#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'ssbmdata';
zci is_cached   => 1;

sub build_structured_answer {
    my ($character, %character_data) = @_;
    my @record_keys = ("Jab", "Jab 2", "Rapid Jab", "Forward Tilt", "Down Tilt", "Up Tilt", "Dash Attack", "Forward Smash", "Up Smash", "Down Smash", "Neutral Air", "Up Air", "Back Air", "Down Air", "Forward Air", "Grab", "Dash Grab", "Down B", "Neutral B", "Side B", "Up B", "Air Dodge", "Spot Dodge", "Roll", "Jump", "Aerial Neutral B", "Gentleman", "Aerial Side B", "Aerial Up B", "Jab 3", "Aerial Down B", "Forward Smash 2", "Taunt", "Backward Roll", "Up B Launch", "Aerial Side B", "Air Grapple", "Hard Side B", "Aerial Up B");
    return 'plain text response',
        structured_answer => {
            data => (
                title       => "Melee Active Frames",
                subtitle    => uc $character,
                record_data => %character_data,
                record_keys => @record_keys
            ),
            templates => (
                group   => 'list',
                options => (
                    content      => 'record',
                    rowHighlight => 1
                )
            )
        };
}

my %mario_data = (
    "Jab" => "2-3", "Jab 2" => "3-4", "Jab 3" => "5-9", "Forward Tilt" => "5-7", "Down Tilt" => "5-8", "Up Tilt" => "4-12", "Dash attack" => "6-25", "Forward Smash" => "12-16", "Up Smash" => "9-11", "Down Smash" => "5-6, 14", "Neutral Air" => "3-32", "Up Air" => "4-9", "Back Air" => "6-17", "Down Air" => "10-11, 13-14, 16-17, 19-20, 22-23, 25-26", "Forward Air" => "18-22", "Grab" => "7-8", "Dash Grab" => "11-12", "Down B" => "8-9, 12-13, 15-16, 18-19, 21-22, 24-25, 27-28, 38-39", "Neutral B" => "14-75", "Side B" => "6-33", "Up B" => "3-24", "Air Dodge" => "4-29", "Spot Dodge" => "2-15", "Roll" => "4-19", "Jump" => "5"
);

ddg_goodie_test(
    [qw( DDG::Goodie::SSBMData )],
    'melee mario' => build_structured_answer('Mario', %mario_data),
    'ssbm frame data mario' => build_structured_answer('Mario', %mario_data),
    'melee frame data' => undef,
    'banana bread' => undef
);


done_testing;
