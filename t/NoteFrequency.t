#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "note_frequency";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::NoteFrequency )],
    "notefreq a4" => test_zci("440"),
    "notefreq gb5" => test_zci("739.988845423269"),
    "notefreq c3 432" => test_zci("128.434368420294"),
    "notefreq a4 100000" => undef,
    "notefreq b#8" => undef,
    "notefreq cb0" => undef,
    "notefreq c9" => undef,
);

done_testing;
