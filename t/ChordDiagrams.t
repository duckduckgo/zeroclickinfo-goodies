#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'chord_diagrams';
zci is_cached => 1;

ddg_goodie_test(
    [ 'DDG::Goodie::ChordDiagrams' ],
    'Amaj9 guitar chord' => test_zci(
	'chord_diagrams',
	structured_answer => {
		id => 'chord_diagrams',
		name => 'Music',
		data => qr/.*/,
		templates => {
			detail => 0,
			item  => 'base_item',
			options => {
				url => "www.ddg.gg",
				content => 'DDH.chord_diagrams.detail'
			},
			variants => {
				tile => 'narrow'
			}
		},
		meta => {},
	}),
	'Cm ukulele chord' => test_zci(
	'chord_diagrams',
	structured_answer => {
		id => 'chord_diagrams',
		name => 'Music',
		data => qr/.*/,
		templates => {
			detail => 0,
			item  => 'base_item',
			options => {
				url => "www.ddg.gg",
				content => 'DDH.chord_diagrams.detail'
			},
			variants => {
				tile => 'narrow'
			}
		},
		meta => {},
	}),
	# check that certain things don't trigger it:
	'C# programming' => undef,
	'C programming' => undef,
	'D programming' => undef,
	'guitar chord finder' => undef,
	'guitar chord fminute' => undef,
	'G' => undef
	);

	done_testing;
