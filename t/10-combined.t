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
	DDG::Goodie::Base64
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

    'reverse bla'                     => test_zci('alb', answer_type => 'reverse', is_cached => 1 ),
    'apples or oranges or cherries'   => test_zci(qr/(random)/, answer_type => 'rand', is_cached => 0),
    'chars hello'                     => test_zci('Chars: 5', answer_type => 'chars', is_cached => 1),
    '10 px to em'                     => test_zci('0.625 em in 10 px', answer_type => 'conversion', is_cached => 1),
    'guid'                            => test_zci(qr/\(randomly generated\)/, answer_type => 'guid', is_cached => 0),
    'golden ratio 1:?'                => test_zci('Golden ratio: 1 : 1.61803398874989', answer_type => 'golden_ratio', is_cached => 1),
    'passphrase 4 words'              => test_zci(qr/random passphrase:/, answer_type => 'passphrase', is_cached => 0),
    'circumference circle 1'          => test_zci('Circumference: 6.28318530717959', answer_type => 'perimeter', is_cached => 1),
    'perimeter hexagon 45'            => test_zci('Perimeter of hexagon: 270', answer_type => 'perimeter', is_cached => 1),
#    'private network'                 => test_zci(qr/Private network IP addressess:/, answer_type => 'private_network', is_cached => 1),
#    'public dns'                      => test_zci(qr/Google Public DNS:/, answer_type => 'public_dns', is_cached => 1),
    'perimeter of triangle 1.5 2 3.2' => test_zci('Perimeter of triangle: 6.7', answer_type => 'perimeter', is_cached => 1),
    'sf 78'                           => test_zci('Significant figures: 2', answer_type => 'sig_figs', is_cached => 1),
    '10 px to em'                     => test_zci(qr/0\.625/, answer_type => 'conversion', is_cached => 1),
    'roman 155'                       => test_zci('CLV (roman numeral conversion)', answer_type => 'roman_numeral_conversion', is_cached => 1),
    'yes or no'                       => test_zci(qr/\w \(random\)/, answer_type => 'rand', is_cached => 0),
    'this or that or none'            => test_zci(qr/\w \(random\)/, answer_type => 'rand', is_cached => 0),
    'throw dice'                      => test_zci(qr/\d \d/, answer_type => 'dice_roll', is_cached => 0),
    '%err 45.125 44.992'              => test_zci(qr/Error:/, html => qr/Error:/, answer_type => 'percent_error', is_cached => 1),
    'chars hello'                     => test_zci('Chars: 5', answer_type => 'chars', is_cached => 1),
    'that to binary'                  => test_zci('01110100011010000110000101110100', answer_type => 'binary_conversion', is_cached => 1),
    'uuid'                            => test_zci(qr/\(randomly generated\)/, answer_type => 'guid', is_cached => 0),
    'avg 12 45 78'                    => test_zci(qr/Mean: 45/, answer_type => 'average', is_cached => 1),
		'base64 encode this text',				=> test_zci(qr/Base64 encoded: dGhpcyB0ZXh0/, answer_type => 'base64_conversion', is_cached => 1),
    );

done_testing;
