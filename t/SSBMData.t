#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'ssbmdata';
zci is_cached   => 1;

sub build_structured_answer {
    my @test_params = @_;
    
    my $mario_data = {
      "Jab" => "2-3",
      "Jab 2" => "3-4",
      "Jab 3" => "5-9",
      "Forward Tilt" => "5-7",
      "Down Tilt" => "5-8",
      "Up Tilt" => "4-12",
      "Dash attack" => "6-25",
      "Forward Smash" => "12-16",
      "Up Smash" => "9-11",
      "Down Smash" => "5-6, 14",
      "Neutral Air" => "3-32",
      "Up Air" => "4-9",
      "Back Air" => "6-17",
      "Down Air" => "10-11, 13-14, 16-17, 19-20, 22-23, 25-26",
      "Forward Air" => "18-22",
      "Grab" => "7-8",
      "Dash Grab" => "11-12",
      "Down B" => "8-9, 12-13, 15-16, 18-19, 21-22, 24-25, 27-28, 38-39",
      "Neutral B" => "14-75",
      "Side B" => "6-33",
      "Up B" => "3-24",
      "Air Dodge" => "4-29",
      "Spot Dodge" => "2-15",
      "Roll" => "4-19",
      "Jump" => "5"
    };

    return 'plain text response',
        structured_answer => {

            data => {
                title       => "Melee Active Frames",
                subtitle    => "Mario",
                record_data => $mario_data
            },

            templates => {
                group   => 'list',
                options => {
                    content      => 'record',
                    rowHighlight => 1
                }
            }

        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::SSBMData )],
    'melee mario' => build_test('query'),
    'ssbm frame data mario' => build_test('query'),
    'melee frame data' => undef,
    'banana bread' => undef
);

done_testing;
