#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;
use Carp::Always;

zci answer_type => 'vim_cheat';

ddg_goodie_test(
	[ 'DDG::Goodie::VimCheatSheet' ],
	'vim cheat sheet' => test_zci(
        qr/^Cursor movement.*Insert Mode.*Editing.*Marking text.*/s,
	    heading => 'Vim Cheat Sheet',
		html => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,
	),
);

done_testing;
