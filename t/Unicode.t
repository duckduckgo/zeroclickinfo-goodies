#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'unicode_conversion';
zci is_cached => 1;

ddg_goodie_test(
        [
            qw(DDG::Goodie::Unicode)
        ],

        # Raw query, "U+XXXX"
        'U+263A' => test_zci("\x{263A} U+263A WHITE SMILING FACE, decimal: 9786, HTML: &#9786;, UTF-8: 0xE2 0x98 0xBA, block: Miscellaneous Symbols"),
        '\u263A' => test_zci("\x{263A} U+263A WHITE SMILING FACE, decimal: 9786, HTML: &#9786;, UTF-8: 0xE2 0x98 0xBA, block: Miscellaneous Symbols"),
        'u263A' => test_zci("\x{263A} U+263A WHITE SMILING FACE, decimal: 9786, HTML: &#9786;, UTF-8: 0xE2 0x98 0xBA, block: Miscellaneous Symbols"),

        # Same should work with the "unicode" start trigger too
        'unicode U+263B' => test_zci("\x{263B} U+263B BLACK SMILING FACE, decimal: 9787, HTML: &#9787;, UTF-8: 0xE2 0x98 0xBB, block: Miscellaneous Symbols"),
        'unicode u263B' => test_zci("\x{263B} U+263B BLACK SMILING FACE, decimal: 9787, HTML: &#9787;, UTF-8: 0xE2 0x98 0xBB, block: Miscellaneous Symbols"),

        # Lookup by name, "unicode LATIN SMALL LETTER A WITH CIRCUMFLEX"
        "unicode White Smiling Face" => test_zci("\x{263A} U+263A WHITE SMILING FACE, decimal: 9786, HTML: &#9786;, UTF-8: 0xE2 0x98 0xBA, block: Miscellaneous Symbols"),

        # Lookup by name, "utf-8 bullet"
        "utf-8 bullet" => test_zci("\x{2022} U+2022 BULLET, decimal: 8226, HTML: &#8226;, UTF-8: 0xE2 0x80 0xA2, block: General Punctuation"),

        # Lookup by name, "utf-16 smile"
        "utf-16 smile" => test_zci("\x{2323} U+2323 SMILE, decimal: 8995, HTML: &#8995;, UTF-8: 0xE2 0x8C 0xA3, block: Miscellaneous Technical"),

        # Lookup by name, "utf-32 custard"
        "utf-32 custard" => test_zci( re("\Q\x{1F36E} U+1F36E CUSTARD, decimal: 127854, HTML: &#127854;, UTF-8: 0xF0 0x9F 0x8D 0xAE, block: Miscellaneous Symbols \E[Aa]nd Pictographs") ),

        # Lookup by name, "emoji rocket"
        "emoji rocket" => test_zci( re("\Q\x{1F680} U+1F680 ROCKET, decimal: 128640, HTML: &#128640;, UTF-8: 0xF0 0x9F 0x9A 0x80, block: Transport \E[Aa]nd Map Symbols") ),

        # Lookup by character, "unicode à"
        "unicode \x{263B}" => test_zci("\x{263B} U+263B BLACK SMILING FACE, decimal: 9787, HTML: &#9787;, UTF-8: 0xE2 0x98 0xBB, block: Miscellaneous Symbols"),

        'U+590c' => test_zci("\x{590C} U+590C CJK UNIFIED IDEOGRAPH-590C, decimal: 22796, HTML: &#22796;, UTF-8: 0xE5 0xA4 0x8C, script: Han, block: CJK Unified Ideographs"),
        'unicode white smiling face' => test_zci("\x{263A} U+263A WHITE SMILING FACE, decimal: 9786, HTML: &#9786;, UTF-8: 0xE2 0x98 0xBA, block: Miscellaneous Symbols"),

        '\x{2764}' => test_zci("\x{2764} U+2764 HEAVY BLACK HEART, decimal: 10084, HTML: &#10084;, UTF-8: 0xE2 0x9D 0xA4, block: Dingbats"),

        'unicode unknown' => undef,
        'utf-15 bullet' => undef
);

done_testing;
