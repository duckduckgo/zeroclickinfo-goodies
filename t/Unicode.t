#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'unicode_conversion';
zci is_cached => 1;

sub build_unicode_answer {
    my ($unicode, $description, $decimal, $UTF, $block) = @_;

    return chr($decimal) . " " . $unicode . " " . $description . ", decimal: " . $decimal . ", HTML: &#" . $decimal . ";, UTF-8: " . $UTF . ", block: " . $block,
        structured_answer => {
            data => {
                title => chr($decimal) . " " . $unicode,
                subtitle => chr($decimal) . " " . $unicode . " " . $description . ", decimal: " . $decimal . ", HTML: &#" . $decimal . ";, UTF-8: " . $UTF . ", block: " . $block
            },
            templates => {
                group => "text",
            }
        };
}

sub build_unicode_test { test_zci(build_unicode_answer(@_)) }

ddg_goodie_test(
    [
        'DDG::Goodie::Unicode'
    ],
    'U+263A' => build_unicode_test('U+263A', 'WHITE SMILING FACE', '9786', '0xE2 0x98 0xBA', 'Miscellaneous Symbols'),
    '\u263A' => build_unicode_test('U+263A', 'WHITE SMILING FACE', '9786', '0xE2 0x98 0xBA', 'Miscellaneous Symbols'),
    'u263A' => build_unicode_test('U+263A', 'WHITE SMILING FACE', '9786', '0xE2 0x98 0xBA', 'Miscellaneous Symbols'),
    'U+263B' => build_unicode_test('U+263B', 'BLACK SMILING FACE', '9787', '0xE2 0x98 0xBB', 'Miscellaneous Symbols'),
    'unicode u263B' => build_unicode_test('U+263B', 'BLACK SMILING FACE', '9787', '0xE2 0x98 0xBB', 'Miscellaneous Symbols'),
    'unicode White Smiling Face' => build_unicode_test('U+263A', 'WHITE SMILING FACE', '9786', '0xE2 0x98 0xBA', 'Miscellaneous Symbols'),
    'utf-8 bullet' => build_unicode_test('U+2022', 'BULLET', '8226', '0xE2 0x80 0xA2', 'General Punctuation'),
    'utf-16 smile' => build_unicode_test('U+2323', 'SMILE', '8995', '0xE2 0x8C 0xA3', 'Miscellaneous Technical'),
    'utf-32 custard' => build_unicode_test('U+1F36E', 'CUSTARD', '127854', '0xF0 0x9F 0x8D 0xAE', 'Miscellaneous Symbols And Pictographs'),
    'emoji rocket' => build_unicode_test('U+1F680', 'ROCKET', '128640', '0xF0 0x9F 0x9A 0x80', 'Transport And Map Symbols'),
    'unicode \x{263B}' => build_unicode_test('U+263B', 'BLACK SMILING FACE', '9787', '0xE2 0x98 0xBB', 'Miscellaneous Symbols'),
    'U+590c' => build_unicode_test('U+590C', 'CJK UNIFIED IDEOGRAPH-590C', '22796', '0xE5 0xA4 0x8C', 'CJK Unified Ideographs'),
    'unicode white smiling face' => build_unicode_test('U+263A', 'WHITE SMILING FACE', '9786', '0xE2 0x98 0xBA', 'Miscellaneous Symbols'),
    '\x{2764}' => build_unicode_test('U+2764', 'HEAVY BLACK HEART', '10084', '0xE2 0x9D 0xA4', 'Dingbats'),
);

done_testing;
