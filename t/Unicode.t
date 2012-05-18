#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'unicode_conversion';
zci is_cached => 1;

# Raw query, "U+XXXX"
ddg_goodie_test(
        [qw(DDG::Goodie::Unicode)],
        'U+263A' => test_zci("\x{263A} U+263A WHITE SMILING FACE, decimal: 9786, HTML: &#9786;, UTF-8: 0xE2 0x98 0xBA, block: Miscellaneous Symbols"),
);

# Same should work with the "unicode" start trigger too
ddg_goodie_test(
        [qw(DDG::Goodie::Unicode)],
        'unicode U+263B' => test_zci("\x{263B} U+263B BLACK SMILING FACE, decimal: 9787, HTML: &#9787;, UTF-8: 0xE2 0x98 0xBB, block: Miscellaneous Symbols"),
);

# Lookup by name, "unicode LATIN SMALL LETTER A WITH CIRCUMFLEX")
ddg_goodie_test(
        [qw(DDG::Goodie::Unicode)],
        "unicode White Smiling Face" => test_zci("\x{263A} U+263A BLACK SMILING FACE, decimal: 9786, HTML: &#9786;, UTF-8: 0xE2 0x98 0xBA, block: Miscellaneous Symbols"),
);

# Lookup by character, "unicode à"
ddg_goodie_test(
        [qw(DDG::Goodie::Unicode)],
        "unicode \x{263B}" => test_zci("\x{263B} U+263B BLACK SMILING FACE, decimal: 9787, HTML: &#9787;, UTF-8: 0xE2 0x98 0xBB, block: Miscellaneous Symbols"),
);

done_testing;
