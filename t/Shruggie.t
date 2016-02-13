#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8; # needed to properly use the various unicode characters in the emoticons

zci answer_type => "shruggie";
zci is_cached   => 1;

sub build_structure
{
    my ($string, $data, $keys) = @_;
    return {
            id => 'shruggie',
            name => 'Shruggie',
            description => 'Emojii for everone',
            templates => {
                group => 'list',
                options => {
                    content => 'record'
                }
            },
            meta => {
                sourceName => "Donger List",
                sourceUrl => "http://dongerlist.com/"
            },
            data => {
                title => $string,
                record_data => $data,
                record_keys => $keys
            }
        };
}


ddg_goodie_test(
    [qw( DDG::Goodie::Shruggie )],
    # At a minimum, be sure to include tests for all:

    # - primary_example_queries
    'shruggie' => test_zci('¯\_(ツ)_/¯',
        structured_answer => {
            id => 'shruggie',
            name => 'Shruggie',
            description => 'Emojii for everone',
            templates => {
                group => 'list',
                options => {
                    content => 'record'
                }

            },
            meta => {
                sourceName => "Donger List",
                sourceUrl => "http://dongerlist.com/"
            },
            data => {
                title => '¯\_(ツ)_/¯',
                record_data => { "Shruggie" => '¯\_(ツ)_/¯'},
                record_keys => ["Shruggie"]
                #subtitle => "Shruggie"  #I like it better without this, but either way is cool
            }}),
    # The next test stresses the JSON file
    # I am sure there is a better way to do this, but I can't figure out the
    # required regex
    #'shruggie and friends' => test_zci("Shruggie and Friends"),
    #

    # - secondary_example_queries
    # Test three random emojiis. Because the config file for the emojiis is
    # desgined to be easily modified to, a full test is not a great idea
    'shruggie and Table Flip' => test_zci('Shruggie and Table Flip',
            structured_answer => build_structure("Shruggie and Table Flip",{
                "Shruggie" => '¯\_(ツ)_/¯',
                "Table Flip" => "(╯°□°）╯︵ ┻━┻"
            },
            ["Shruggie", "Table Flip"]
        )),
    'shruggie and Anon' => test_zci('Shruggie and Anon',
            structured_answer => build_structure('Shruggie and Anon',{
                "Shruggie" => '¯\_(ツ)_/¯',
                "Anon" => "ლ(ಠ益ಠლ)﻿"
            },
            ["Shruggie", "Anon"]
        )),
    'shruggie AND hug me' => test_zci('Shruggie and Hug Me',
            structured_answer => build_structure('Shruggie and Hug Me',{
                "Shruggie" => '¯\_(ツ)_/¯',
                "Hug Me" => "(っ◕‿◕)っ"
            },
            ["Shruggie", "Hug Me"]
        )),
    'table flip emoji' => test_zci('Shruggie Table flip',
            structured_answer => build_structure('Shruggie Table flip',{
                "Table flip" => "(╯°□°）╯︵ ┻━┻"
            },
            ["Table flip"]
        )),
    'Cry kaomoji' => test_zci('Shruggie Cry',
            structured_answer => build_structure('Shruggie Cry',{
                "Cry" => "(╯︵╰,)"
            },
            ["Cry"]
        )),
    'pig face mark' => test_zci('Shruggie Pig',
            structured_answer => build_structure('Shruggie Pig',{
                "Pig" => "(∩◕(oo)◕∩ )"
            },
            ["Pig"]
        )),
    'emoji Table flip' => test_zci('Shruggie Table flip',
            structured_answer => build_structure('Shruggie Table flip',{
                "Table flip" => "(╯°□°）╯︵ ┻━┻"
            },
            ["Table flip"]
        )),
    'table flip ascii' => test_zci('Shruggie Table flip',
            structured_answer => build_structure('Shruggie Table flip',{
                "Table flip" => "(╯°□°）╯︵ ┻━┻"
            },
            ["Table flip"]
        )),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'shruggie and' => undef,
    'shruggie and friendss' => undef,
    'shruggie andover' => undef,
    'ascii table flip' => undef
);

done_testing;
