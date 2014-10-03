#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'tmux_cheat';
zci is_cached   => 1;

# This goodie always returns the same answer whenever its triggered
my $test_zci = test_zci(
        qr/^Session Control.*Window Control.*Pane Control.*/s,
	    heading => 'Tmux Cheat Sheet',
		html => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,
);

ddg_goodie_test(
	[ 'DDG::Goodie::TmuxCheatSheet' ],
    'tmux cheat sheet'      => $test_zci,
    'tmux cheatsheet'       => $test_zci,
    'tmux commands'         => $test_zci,
    'tmux guide'            => $test_zci,
    'tmux help'             => $test_zci,
    'tmux quick reference'  => $test_zci,
    'tmux reference'        => $test_zci,
    'cheatsheet tmux'       => $test_zci,
    'cheat sheet tmux'      => $test_zci,
    'guide tmux',           => $test_zci,
    'reference tmux',       => $test_zci,
    'quick reference tmux', => $test_zci,
    'help tmux',            => $test_zci,
);

done_testing;
