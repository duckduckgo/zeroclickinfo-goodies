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
	'random chess960 position' => test_zci(qr/^Position \d{1,3}:
White: ([BKNQRP] ?){1,8}
       ([BKNQRP] ?){0,8}
Black: ([BKNQRP] ?){1,8}
       ([BKNQRP] ?){0,8}

\(where B is for bishop,
       K is for king,
       N is for knight,
       Q is for queen,
       R is for rook, and
       P is for pawn\)$/,

    html => qr|^<a href='https://en.wikipedia.org/wiki/Chess960_numbering_scheme'>Position \d{1,3}</a><br><img src='/iu/\?u=http://www\.apronus\.com/chess/stilldiagram\.php\?d=[BKNQRPbknqrp]{0,16}PPPPPPPP________________________________pppppppp[bknqrpBKNQRP]{0,16}0.jpg&w=8&h=8'/>$|,

    heading => 'random position (Chess960)'
    )
);

done_testing;

