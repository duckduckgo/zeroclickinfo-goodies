#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "emacs_cheat_sheet";
zci is_cached   => 1;

my $test_zci = test_zci(
	    heading => 'Emacs Cheat Sheet',
        html    => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,
);

ddg_goodie_test(
    [ 'DDG::Goodie::EmacsCheatSheet' ],
    'emacs cheatsheet'      => $test_zci,
    'emacs cheat sheet'     => $test_zci,
    'emacs help'            => $test_zci,
    'emacs commands'        => $test_zci,
    'emacs guide'           => $test_zci,
    'emacs reference'       => $test_zci,
    'emacs quick reference' => $test_zci,
);

done_testing;
