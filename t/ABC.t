#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rand';
zci is_cached   => 0;

ddg_goodie_test(
	[qw( DDG::Goodie::ABC )],
    'choose'                                      => undef,
    'i choose'                                    => undef,
    'choose or'                                   => undef,
    'choose my house or your house'               => undef,
    'choose his or her house'                     => undef,
    'choose his or or her house'                  => undef,
    'choose from products like turkey or venison' => undef,
	'choose pick or axe'            => test_zci(qr/(pick|axe) \(random\)/),
	'choose yes or no'              => test_zci(qr/(yes|no) \(random\)/),
    'choose this or that or none'   => test_zci(qr/(this|that|none) \(random\)/),
    'pick this or that or none'     => test_zci(qr/(this|that|none) \(random\)/),
    'select heads or tails'         => test_zci(qr/(heads|tails) \(random\)/),
    'choose heads or tails'         => test_zci(qr/(heads|tails) \(random\)/),
    'choose duckduckgo or google or bing or something' => test_zci("duckduckgo (not random)", answer_type => 'egg'),
    'choose DuckDuckGo OR Google OR Bing OR SOMETHING' => test_zci("DuckDuckGo (not random)", answer_type => 'egg'),
);

done_testing;

