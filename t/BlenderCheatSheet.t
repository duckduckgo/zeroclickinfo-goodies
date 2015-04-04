#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "blender_cheat_sheet";
zci is_cached   => 1;

ddg_goodie_test(
    [ 'DDG::Goodie::BlenderCheatSheet' ],
    "blender cheat sheet"     => $test_zci,
    "blender cheatsheet"     => $test_zci,
    "blender shortcuts" => $test_zci,
    "blender key bindings"       => $test_zci,
    "blender help"        => $test_zci
);

done_testing;
