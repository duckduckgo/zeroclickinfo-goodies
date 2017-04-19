#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "music_scale";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::MusicScale )],
    "a minor scale" => test_zci(
        "A, B, C, D, E, F, G",
        structured_answer => {
            input     => ["A Minor Scale"],
            operation => "Musical Scale",
            result    => "A, B, C, D, E, F, G"
        }),
    "c major scale" => test_zci(
        "C, D, E, F, G, A, B",
        structured_answer => {
            input     => ["C Major Scale"],
            operation => "Musical Scale",
            result    => "C, D, E, F, G, A, B"
        }),
    "g# phrygian scale" => test_zci(
        "Ab/G#, A, B, Db/C#, Eb/D#, E, Gb/F#",
        structured_answer => {
            input     => ["G# Phrygian Scale"],
            operation => "Musical Scale",
            result    => "Ab/G#, A, B, Db/C#, Eb/D#, E, Gb/F#"
        }),
    "g# silly scale" => undef,
    "the d minor scale" => undef,
    "a minor scale notes" => undef,
);

done_testing;
