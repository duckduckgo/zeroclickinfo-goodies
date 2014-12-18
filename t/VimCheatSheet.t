#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'vim_cheat';
zci is_cached   => 1;

# This goodie always returns the same answer whenever its triggered
my $test_zci = test_zci(
        qr/^Cursor movement.*Insert mode.*Editing.*Marking text.*/s,
	    heading => 'Vim Cheat Sheet',
		html => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,
);

ddg_goodie_test(
	[ 'DDG::Goodie::VimCheatSheet' ],
    'vi cheat sheet'       => $test_zci,
    'vi cheatsheet'        => $test_zci,
    'vi commands'          => $test_zci,
    'vi guide'             => $test_zci,
    'vi help'              => $test_zci,
    'vi quick reference'   => $test_zci,
    'vi reference'         => $test_zci,
    'vim cheat sheet'      => $test_zci,
    'vim cheatsheet'       => $test_zci,
    'vim commands'         => $test_zci,
    'vim guide'            => $test_zci,
    'vim help'             => $test_zci,
    'vim quick reference'  => $test_zci,
    'vim reference'        => $test_zci,
);

done_testing;
