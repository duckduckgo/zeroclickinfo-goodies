#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

ddg_goodie_test(
    [qw(
	DDG::Goodie::ABC
    DDG::Goodie::Ascii
    DDG::Goodie::AspectRatio
	DDG::Goodie::Average
    DDG::Goodie::Base
	DDG::Goodie::Base64
	DDG::Goodie::Binary
	DDG::Goodie::Capitalize
	DDG::Goodie::Chars
	DDG::Goodie::CurrencyIn
	DDG::Goodie::DaysBetween
	DDG::Goodie::Dice
	DDG::Goodie::EmToPx
	DDG::Goodie::FlipText
	DDG::Goodie::GUID
	DDG::Goodie::GoldenRatio
    DDG::Goodie::HTMLEntities
    DDG::Goodie::NLetterWords
	DDG::Goodie::Passphrase
	DDG::Goodie::PercentError
	DDG::Goodie::Perimeter
	DDG::Goodie::PrivateNetwork
	DDG::Goodie::PublicDNS
	DDG::Goodie::Reverse
	DDG::Goodie::Roman
	DDG::Goodie::SigFigs
	DDG::Goodie::TitleCase
	DDG::Goodie::Unicode
    DDG::Goodie::Unidecode
	DDG::Goodie::Xor
    )],

    # ABC
    'reverse bla'                     => test_zci('alb', answer_type => 'reverse', is_cached => 1 ),
    'apples or oranges or cherries'   => test_zci(qr/(random)/, answer_type => 'rand', is_cached => 0),
    'yes or no'                       => test_zci(qr/\w \(random\)/, answer_type => 'rand', is_cached => 0),
    'this or that or none'            => test_zci(qr/\w \(random\)/, answer_type => 'rand', is_cached => 0),

    # ASCII
    '01101010 to ascii'               => test_zci('j', answer_type => 'ascii_conversion', is_cached => 1),
	'00111001 to ascii'               => test_zci('9', answer_type => 'ascii_conversion', is_cached => 1),
	'01110100011010000110100101110011 in ascii' => test_zci('this', answer_type => 'ascii_conversion', is_cached => 1),
    '01110100011010000110000101110100 to ascii' => test_zci('that', answer_type => 'ascii_conversion', is_cached => 1),

    # AspectRatio
	'aspect ratio 4:3 640:?'          => test_zci('Aspect ratio: 640:480 (4:3)', answer_type => 'aspect_ratio', is_cached => 1),
	'aspect ratio 4:3 ?:480'          => test_zci('Aspect ratio: 640:480 (4:3)', answer_type => 'aspect_ratio', is_cached => 1),
	'aspect ratio 1:1.5 20:?'         => test_zci('Aspect ratio: 20:30 (1:1.5)', answer_type => 'aspect_ratio', is_cached => 1),
	'aspect ratio 1:1.5 ?:15'         => test_zci('Aspect ratio: 10:15 (1:1.5)', answer_type => 'aspect_ratio', is_cached => 1),

    # Average
    'avg 12 45 78'                    => test_zci(qr/Mean: 45/, answer_type => 'average', is_cached => 1),

    # Binary
    'that to binary'                  => test_zci('\"that\" as a string is 01110100011010000110000101110100 in binary.', answer_type => 'binary_conversion', is_cached => 1),

    # Base64
    'base64 encode this text'         => test_zci(qr/Base64 encoded: dGhpcyB0ZXh0/, answer_type => 'base64_conversion', is_cached => 1),


    # Chars
    'chars hello'                     => test_zci('Chars: 5', answer_type => 'chars', is_cached => 1),

    # CurrencyIn
    'currency in australia' => test_zci('The currency in Australia is the Australian dollar (AUD)', html => 'The currency in Australia is the Australian dollar (AUD)<br />', answer_type => 'currency_in', is_cached => 1),

    # DaysBetween
    'days between 01/01/2000 01/01/2001' => test_zci('There are 366 days between 01/01/2000 and 01/01/2001.', answer_type => 'days_between', is_cached => 1),
    'days between 1/1/2000 and 1/1/2001 inclusive' => test_zci('There are 367 days between 1/1/2000 and 1/1/2001, inclusive.', answer_type => 'days_between', is_cached => 1),

    # Dice
    'throw dice'                      => test_zci(qr/\d \d/, answer_type => 'dice_roll', is_cached => 0),

    # EmToPx
    '10 px to em'                     => test_zci('0.625 em in 10 px', answer_type => 'conversion', is_cached => 1),

    # GUID
    'guid'                            => test_zci(qr/\(randomly generated\)/, answer_type => 'guid', is_cached => 0),
    'uuid'                            => test_zci(qr/\(randomly generated\)/, answer_type => 'guid', is_cached => 0),

    # GoldenRatio
    'golden ratio 1:?'                => test_zci('Golden ratio: 1 : 1.61803398874989', answer_type => 'golden_ratio', is_cached => 1),

    # HTMLEntities
	'&#33;'                           => test_zci("Decoded HTML Entity: !, decimal: 33, hexadecimal: 0021", html => "Decoded HTML Entity: !, decimal: 33, hexadecimal: <a href=\"/?q=U%2B0021\">0021</a>", answer_type => 'html_entity', is_cached => 1),
	'&#x21'                           => test_zci("Decoded HTML Entity: !, decimal: 33, hexadecimal: 0021", html => "Decoded HTML Entity: !, decimal: 33, hexadecimal: <a href=\"/?q=U%2B0021\">0021</a>", answer_type => 'html_entity', is_cached => 1),
	'html entity &amp;'               => test_zci("Decoded HTML Entity: &, decimal: 38, hexadecimal: 0026", html => "Decoded HTML Entity: &, decimal: 38, hexadecimal: <a href=\"/?q=U%2B0026\">0026</a>", answer_type => 'html_entity', is_cached => 1),

    # NLetterWords
    '1 letter words'                  => test_zci('1 letter words: a, I', answer_type => 'nletterwords', is_cached => 0),
    '1 char words'                    => test_zci('1 letter words: a, I', answer_type => 'nletterwords', is_cached => 0),
    '1 character word'               => test_zci('1 letter words: a, I', answer_type => 'nletterwords', is_cached => 0),

    # Passphrase
    'passphrase 4 words'              => test_zci(qr/random passphrase:/, answer_type => 'passphrase', is_cached => 0),

    # PercentError
    '%err 45.125 44.992'              => test_zci(qr/Error:/, html => qr/Error:/, answer_type => 'percent_error', is_cached => 1),

    # Perimeter
    'circumference circle 1'          => test_zci('Circumference: 6.28318530717959', answer_type => 'perimeter', is_cached => 1),
    'perimeter hexagon 45'            => test_zci('Perimeter of hexagon: 270', answer_type => 'perimeter', is_cached => 1),
    'perimeter of triangle 1.5 2 3.2' => test_zci('Perimeter of triangle: 6.7', answer_type => 'perimeter', is_cached => 1),

    # PrivateNetwork
    #'private network'                 => test_zci(qr/Private network IP addressess:/, answer_type => 'private_network', is_cached => 1),

    # PubicDNS
    #'public dns'                      => test_zci(qr/Google Public DNS:/, answer_type => 'public_dns', is_cached => 1),

    # Roman
    'roman 155'                       => test_zci('CLV (roman numeral conversion)', answer_type => 'roman_numeral_conversion', is_cached => 1),

    # SigFigs
    'sf 78'                           => test_zci('Significant figures: 2', answer_type => 'sig_figs', is_cached => 1),

    # Unicode
    'U+263A'                          => test_zci("\x{263A} U+263A WHITE SMILING FACE, decimal: 9786, HTML: &#9786;, UTF-8: 0xE2 0x98 0xBA, block: Miscellaneous Symbols", answer_type => 'unicode_conversion', is_cached => 1),

    # Unidecode
    "unidecode \x{5317}\x{4EB0}"      => test_zci('Bei Jing', answer_type => 'convert to ascii', is_cached => 1),

);

done_testing;
