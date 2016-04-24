#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "note_frequency";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::NoteFrequency )],
    "notefreq a4" => test_zci(
        "440",
        structured_answer => {
            input     => ["A4 in A440 tuning"],
            operation => "Note Frequency",
            result    => "440 Hz"
        }),
    "notefreq gb5" => test_zci(
        "739.99",
        structured_answer => {
            input     => ["Gb5 in A440 tuning"],
            operation => "Note Frequency",
            result    => "739.99 Hz"
        }),
    "notefreq c3 432" => test_zci(
        "128.43",
        structured_answer => {
            input     => ["C3 in A432 tuning"],
            operation => "Note Frequency",
            result    => "128.43 Hz"
        }),
    "notefreq c3 432Hz" => test_zci(
        "128.43",
        structured_answer => {
            input     => ["C3 in A432 tuning"],
            operation => "Note Frequency",
            result    => "128.43 Hz"
        }),
    "notefreq c3 432  Hz" => undef,
    "notefreq a4 100000" => undef,
    "notefreq b#8" => undef,
    "notefreq cb0" => undef,
    "notefreq c9" => undef,
);

done_testing;
