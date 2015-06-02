#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "blender_cheat_sheet";
zci is_cached   => 1;

my $test_zci = test_zci(
        qr/^Basics.*General.*Movements.*Navigation.*Selection.*Fly mode.*Switching modes.*Modelling.*Editing curves.*Sculpting.*Animation.*Node Editor.*Armatures.*Pose mode.*Timeline.*Video Sequence Editor.*/s,
        heading => "Blender Cheat Sheet",
        html => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,
);

ddg_goodie_test(
    [qw( DDG::Goodie::BlenderCheatSheet )],
    "blender cheat sheet"     => $test_zci,
    "blender cheatsheet"     => $test_zci,
    "blender shortcuts" => $test_zci,
    "blender key bindings"       => $test_zci,
    "blender help"        => $test_zci,
    
    # bad search bad
    "blender pasta" => undef,
    "blender short" => undef,
    "bender guide" => undef,
);

done_testing;
