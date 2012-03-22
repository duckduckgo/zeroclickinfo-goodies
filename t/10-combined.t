#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

ddg_goodie_test(
	[qw(
		DDG::Goodie::ABC
		DDG::Goodie::Average
                DDG::Goodie::Base
		DDG::Goodie::Base32
		DDG::Goodie::Binary
		DDG::Goodie::Capitalize
		DDG::Goodie::Chars
		DDG::Goodie::Dice
		DDG::Goodie::EmToPx
		DDG::Goodie::FlipText
		DDG::Goodie::GUID
		DDG::Goodie::GoldenRatio
		DDG::Goodie::Passphrase
		DDG::Goodie::PercentError
		DDG::Goodie::Perimeter
		DDG::Goodie::Reverse
		DDG::Goodie::Roman
		DDG::Goodie::SigFigs
		DDG::Goodie::TitleCase
		DDG::Goodie::Unicode
		DDG::Goodie::Xor
		DDG::Goodie::PrivateNetwork
		DDG::Goodie::PublicDNS
	)],
	'reverse bla'                   => test_zci('alb', answer_type => 'reverse', is_cached => 1 ),
        'apples or oranges or cherries' => test_zci(qr/(random)/, answer_type => 'rand', is_cached => 0),
        'chars hello'                   => test_zci('Chars: 5', answer_type => 'chars', is_cached => 1),
        '10 px to em'                   => test_zci('0.625 em in 10 px', answer_type => 'conversion', is_cached => 1),
        'guid'                          => test_zci(qr/\(randomly generated\)/, answer_type => 'guid', is_cached => 0),
        'golden ratio 1:?'              => test_zci('Golden ratio: 1 : 1.61803398874989', answer_type => 'golden_ratio', is_cached => 1),
        'passphrase 4 words'            => test_zci(qr/random passphrase:/, answer_type => 'passphrase', is_cached => 0),
#        ''                             => test_zci('', answer_type => '', is_cached => 0),
);

done_testing;

