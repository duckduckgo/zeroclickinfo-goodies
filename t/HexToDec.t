#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'conversion';
zci is_cached   => 1;

ddg_goodie_test(
	[qw( DDG::Goodie::HexToDec )],
	'0xd1038d2e07b42569' => test_zci(
        'd1038d2e07b42569 base 16 = 15061036807694329193 base 10 = 01504034322700755022551 base 8',
        html => "<style type='text/css'>.zci--answer .zci--hextodec {
    font-weight: 300;
    word-break: break-word;
}
.zci--answer .zci--hextodec .hextodec--decimal {
    font-size: 1.7em;
}
</style><div class='zci--hextodec text--primary'><div class='hextodec--decimal'><span class='text--secondary'>Decimal:</span> 15061036807694329193</div><div><span class='text--secondary'>Octal: </span> 01504034322700755022551</div></div>"),
	'0x44696f21' => test_zci(
        '44696f21 base 16 = 1147760417 base 10 = 010432267441 base 8',
        html => "<style type='text/css'>.zci--answer .zci--hextodec {
    font-weight: 300;
    word-break: break-word;
}
.zci--answer .zci--hextodec .hextodec--decimal {
    font-size: 1.7em;
}
</style><div class='zci--hextodec text--primary'><div class='hextodec--decimal'><span class='text--secondary'>Decimal:</span> 1147760417</div><div><span class='text--secondary'>Octal: </span> 010432267441</div></div>"),
    '0xffffffffffffffffffffff' => test_zci('ffffffffffffffffffffff base 16 = 309485009821345068724781055 base 10 = 0177777777777777777777777777777 base 8',
        html => "<style type='text/css'>.zci--answer .zci--hextodec {
    font-weight: 300;
    word-break: break-word;
}
.zci--answer .zci--hextodec .hextodec--decimal {
    font-size: 1.7em;
}
</style><div class='zci--hextodec text--primary'><div class='hextodec--decimal'><span class='text--secondary'>Decimal:</span> 309485009821345068724781055</div><div><span class='text--secondary'>Octal: </span> 0177777777777777777777777777777</div></div>"),
    '0x44696f2Z' => undef,
);

done_testing;

