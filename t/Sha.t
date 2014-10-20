#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sha';
zci is_cached   => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::Sha
	)],
	'shasum the duckdukcgo serach engine' => test_zci('8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4', html=>qr/.*/),
	'sha1sum the duckdukcgo serach engine' => test_zci('8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4', html=>qr/.*/),
	'sha-1 the duckdukcgo serach engine' => test_zci('8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4', html=>qr/.*/),
	'sha256sum base64 the duckdukcgo serach engine' => test_zci('XUKkFU44G21/OPBB47hIwC3Q1lb1Cl8ktI2GjyCDFrM=', html=>qr/.*/),
	'sha256sum base64 the duckdukcgo serach engine' => test_zci('XUKkFU44G21/OPBB47hIwC3Q1lb1Cl8ktI2GjyCDFrM=', html=>qr/.*/),
	'sha-256 base64 the duckdukcgo serach engine' => test_zci('XUKkFU44G21/OPBB47hIwC3Q1lb1Cl8ktI2GjyCDFrM=', html=>qr/.*/),
	'sha-1 base64 lorem ipsum' => test_zci('v7d1mmfa62VBBJC02Yu52n0eos4=', html=>qr/.*/),
	'sha-224 base64 lorem ipsum' => test_zci('4ZHt8GAFcSWDUYztkswqwvrI1uRiOwIaUHNqkQ==', html=>qr/.*/),
	'sha-256 base64 lorem ipsum' => test_zci('Xiv1fT9AxLbfadrxk2y3ZvgyN0tPwCWafL/wbi9w8mk=', html=>qr/.*/),
	'sha-384 base64 lorem ipsum' => test_zci('WXSTps8SiXV1JOVN/W9oszLHIUpxajNYkR71wJkHrcimVKGMHXIeGDsAJfmW9uJG', html=>qr/.*/),
	'sha-512 base64 lorem ipsum' => test_zci('+A7r2aq7GhX7hp7VaNhYpcDco9XaB6QQ4b2Yh2ORjZc+NEgUYl98hEaVst42/9J68pDQ40NixR3uWUfVjUBSeg==', html=>qr/.*/),
	'shasum hex this' => test_zci('c2543fff3bfa6f144c2f06a7de6cd10c0b650cae', html=>qr/.*/),
	'sha224sum base64 this' => test_zci('kFct0af7OnZ8E66tO0CmyDv1uXW7nSRHon3JYg==', html=>qr/.*/),

	'shasum <script>alert( "hello" )<script>' => test_zci('10c4a3b691419901a56fade7e4b5e04fe4ef6570', html=> qr/.*SHA-1 of "&lt;script&gt;alert\( &quot;hello&quot; \)&lt;script&gt;".*/),
	'shasum script>ALERT hello script>' => test_zci('9ef5127abf5a46ef82a1bc10e6a8447a205644cd', html=>qr/.*SHA-1 of "script&gt;ALERT hello script&gt;".*/),
);

done_testing;
