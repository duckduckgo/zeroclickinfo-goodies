#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'chess960_position';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Chess960
	)],
    map {
        $_ => test_zci(qr/^[qrkbn]{1,8}
pppppppp
 - - - -
- - - - 
 - - - -
- - - - 
PPPPPPPP
[QRBKN]{1,8}$/,
            html    => qr/^<div class="zci--fenviewer"><table class="chess_board" cellpadding="0" cellspacing="0">(<tr>(<td id="[A-H][1-8]"><a href="#" class="[a-z ]*">.*<\/a><\/td>){1,8}<\/tr>){1,8}<\/table><\/div>$/,
            heading => qr/^Position \d+ \(Chess960\)$/,
        )
    } ('random chess960 position', 'chess960 random')
);

done_testing;

