#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'gnuscreen_cheat';
zci is_cached   => 1;

# This goodie always returns the same answer whenever its triggered
my $test_zci = test_zci(
        qr/^Session Control.*Main Commands.*Window Commands.*Copying and Scrolling.*/s,
	    heading => 'GNU Screen Cheat Sheet',
		html => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,
);

ddg_goodie_test(
  [ 'DDG::Goodie::GnuScreenCheatSheet' ],
    'screen cheat sheet'      => $test_zci,
    'screen cheatsheet'       => $test_zci,
    'screen commands'         => $test_zci,
    'screen guide'            => $test_zci,
    'screen help'             => $test_zci,
    'screen quick reference'  => $test_zci,
    'screen reference'        => $test_zci,
    'cheatsheet screen'       => $test_zci,
    'cheat sheet screen'      => $test_zci,
    'guide screen',           => $test_zci,
    'reference screen',       => $test_zci,
    'quick reference screen', => $test_zci,
    'help screen',            => $test_zci,
);

done_testing;
