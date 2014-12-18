#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "gimp_cheat";
zci is_cached   => 1;

# This goodie always returns the same answer whenever its triggered
my $test_zci = test_zci(
        qr/^Help.*Tools.*File.*Edit.*Zoom tool.*/s,
        heading => "GIMP Shortcut Cheat Sheet",
        html => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,
);

ddg_goodie_test(
    [ 'DDG::Goodie::GimpCheatSheet' ],
    "gimp cheat sheet"     => $test_zci,
    "gimp cheatsheet"      => $test_zci,
    "gimp help"            => $test_zci,
    "gimp quick reference" => $test_zci,
    "gimp reference"       => $test_zci,
    "gimp shortcut"        => $test_zci,
    "gimp shortcuts"       => $test_zci
);

done_testing;

