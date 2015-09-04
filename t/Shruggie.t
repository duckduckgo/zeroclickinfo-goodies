#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8; # needed to properly use the various unicode characters in the emoticons

zci answer_type => "shruggie";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Shruggie )],
    # At a minimum, be sure to include tests for all:
    
    # - primary_example_queries
    'shruggie' => test_zci('¯\_(ツ)_/¯',
        structured_answer => {
            input     => [],
            result    => '¯\_(ツ)_/¯',
        }    
    ),
    # The next test stresses the JSON file
    # I am sure there is a better way to do this, but I can't figure out the 
    # required regex
    'shruggie and friends' => test_zci(qr/.*/,
        structured_answer => {
            input     => [],
            result    => qr/.*/,
        }    
    ),
    
    # - secondary_example_queries
    # Test three random emojiis. Because the config file for the emojiis is
    # desgined to be easily modified to, a full test is not a great idea
    'shruggie and Table Flip' => test_zci('¯\_(ツ)_/¯ ____ (╯°□°）╯︵ ┻━┻',
        structured_answer => {
            input     => [],
            result    => '¯\_(ツ)_/¯ ____ (╯°□°）╯︵ ┻━┻',
        }    
    ),
    'shruggie and Anon' => test_zci('¯\_(ツ)_/¯ ____ ლ(ಠ益ಠლ)﻿',
        structured_answer => {
            input     => [],
            result    => '¯\_(ツ)_/¯ ____ ლ(ಠ益ಠლ)﻿',
        }    
    ),
    'shruggie AND hug me' => test_zci('¯\_(ツ)_/¯ ____ (っ◕‿◕)っ',
        structured_answer => {
            input     => [],
            result    => '¯\_(ツ)_/¯ ____ (っ◕‿◕)っ',
        }    
    ),
    
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'shruggie and' => undef,
    'shruggie and friendss' => undef,
    'shruggie andover' => undef
);

done_testing;
