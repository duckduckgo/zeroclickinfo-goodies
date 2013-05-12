#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => "unicodefuzzysearch";

ddg_goodie_test(
    [qw(
                DDG::Goodie::UnicodeFuzzySearch
        )],
    # ------
    "unicode white heart" =>
	test_zci("WHITE HEART SUIT: \x{2661} (U+2661)", html => "WHITE HEART SUIT: \x{2661} (U+2661)"),
    "0f00 unicode" =>
	test_zci("TIBETAN SYLLABLE OM: \x{0f00} (U+0F00)", html => ("TIBETAN SYLLABLE OM: \x{0f00} (U+0F00)")),
    # ------
    "unicode snowman" =>
	test_zci("SNOWMAN: \x{2603} (U+2603)
SNOWMAN WITHOUT SNOW: \x{26c4} (U+26C4)
BLACK SNOWMAN: \x{26c7} (U+26C7)",
             html => "<ul><li>SNOWMAN: \x{2603} (U+2603)</li><li>SNOWMAN WITHOUT SNOW: \x{26c4} (U+26C4)</li><li>BLACK SNOWMAN: \x{26c7} (U+26C7)</li></ul>"),
    # ------
    "sharp s unicode" =>
	test_zci("LATIN SMALL LETTER SHARP S: \x{00df} (U+00DF)
LATIN CAPITAL LETTER SHARP S: \x{1e9e} (U+1E9E)
MUSIC SHARP SIGN: \x{266f} (U+266F)",
             html => "<ul><li>LATIN SMALL LETTER SHARP S: \x{00df} (U+00DF)</li><li>LATIN CAPITAL LETTER SHARP S: \x{1e9e} (U+1E9E)</li><li>MUSIC SHARP SIGN: \x{266f} (U+266F)</li></ul>"),
    );

done_testing;
