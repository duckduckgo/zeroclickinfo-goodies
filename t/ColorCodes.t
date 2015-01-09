#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'color_code';
zci is_cached => 1;

ddg_goodie_test(
	[qw(DDG::Goodie::ColorCodes)],
    'hex color code for cyan' => test_zci(
        'Hex: #00FFFF ~ rgba(0, 255, 255, 1) ~ rgb(0%, 100%, 100%) ~ hsl(180, 100%, 50%) ~ cmyb(100%, 0%, 0%, 0%)'."\n".'Complementary: #FF0000'."\n".'Analogous: #0080FF, #0000FF',
        html => qr/background:#00ffff/,
    ),
    'rgb(173,216,230)' => test_zci(
        'Hex: #ADD8E6 ~ rgba(173, 216, 230, 1) ~ rgb(68%, 85%, 90%) ~ hsl(195, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%)'."\n".'Complementary: #E6BAAC'."\n".'Analogous: #ACBAE6, #BAACE6',
        html => qr/background:#add8e6/,
    ),
    'hsl 194 0.53 0.79' => test_zci(
        'Hex: #ADD8E5 ~ rgba(173, 216, 229, 1) ~ rgb(68%, 85%, 90%) ~ hsl(194, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%)'."\n".'Complementary: #E6BBAE'."\n".'Analogous: #AEBDE6, #BBAEE6',
        html => qr/background:#add8e5/,
    ),
    'cmyk(0.12, 0, 0, 0)' => test_zci(
        'Hex: #E0FFFF ~ rgba(224, 255, 255, 1) ~ rgb(88%, 100%, 100%) ~ hsl(180, 100%, 94%) ~ cmyb(12%, 0%, 0%, 0%)'."\n".'Complementary: #FFE0E0'."\n".'Analogous: #E0F0FF, #E0E0FF',
        html => qr/background:#e0ffff/,
    ),
    '#00ff00' => test_zci(
        'Hex: #00FF00 ~ rgba(0, 255, 0, 1) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%)'."\n".'Complementary: #FF00FF'."\n".'Analogous: #00FF80, #00FFFF',
        html => qr/background:#00ff00/,
    ),
    '#0f0' => test_zci(
        'Hex: #00FF00 ~ rgba(0, 255, 0, 1) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%)'."\n".'Complementary: #FF00FF'."\n".'Analogous: #00FF80, #00FFFF',
        html => qr/background:#00ff00/,
    ),
    'inverse of the color red' => test_zci(
        'Hex: #00FFFF ~ rgba(0, 255, 255, 1) ~ rgb(0%, 100%, 100%) ~ hsl(180, 100%, 50%) ~ cmyb(100%, 0%, 0%, 0%)'."\n".'Complementary: #FF0000'."\n".'Analogous: #0080FF, #0000FF',
        html => qr/background:#00ffff/,
    ),
    'rgb(0 255 0)\'s inverse' => test_zci(
        'Hex: #FF00FF ~ rgba(255, 0, 255, 1) ~ rgb(100%, 0%, 100%) ~ hsl(300, 100%, 50%) ~ cmyb(0%, 100%, 0%, 0%)'."\n".'Complementary: #00FF00'."\n".'Analogous: #FF0080, #FF0000',
        html => qr/background:#ff00ff/,
    ),
    'html bluishblack' => test_zci(
        'Hex: #202428 ~ rgba(32, 36, 40, 1) ~ rgb(13%, 14%, 16%) ~ hsl(210, 11%, 14%) ~ cmyb(20%, 10%, 0%, 84%)'."\n".'Complementary: #292521'."\n".'Analogous: #212129, #252129',
        html => qr/background:#202428/,
    ),
    # Single full HTML check.
    'red html code' => test_zci(
        'Hex: #FF0000 ~ rgba(255, 0, 0, 1) ~ rgb(100%, 0%, 0%) ~ hsl(0, 100%, 50%) ~ cmyb(0%, 100%, 100%, 0%)'."\n".'Complementary: #00FFFF'."\n".'Analogous: #FF8000, #FFFF00',
        html => qq(<div class="zci--color-codes"><div class="colorcodesbox circle" style="background:#ff0000"></div><div class='col1'><p class='hex zci__caption'>Hex: #FF0000</p><p class='no_vspace'>rgba(255, 0, 0, 1)</p><p class='no_vspace'>hsl(0, 100%, 50%)</p><p class='no_vspace'>cmyb(0%, 100%, 100%, 0%)</p><p ><a href='http://labs.tineye.com/multicolr#colors=Hex: #FF0000;weights=100;' class='tx-clr--lt'>Images</a> | <a href='http://www.color-hex.com/color/Hex: #FF0000' title='Tints, information and similar colors on color-hex.com' class='tx-clr--lt'>Info</a></p></div><div class='col2'><div><div class='cols_column'><span class='mini-color circle' style='background: #00ffff;'> </span></div><div class='desc_column'><p class='no_vspace'>Complementary #:</p><p class='no_vspace text--primary'>00FFFF</p></div></div><div><div class='cols_column'><span class='mini-color circle' style='background: #ff8000'> </span><span class='mini-color circle' style='background: #ffff00'> </span></div><div class='desc_column'><p class='no_vspace'>Analogous #:</p><p class='no_vspace text--primary'>FF8000, FFFF00</p></div></div></div></div>)
    ),
    'rgba(99,60,176,0.5)' => test_zci(
        'Hex: #633CB0 ~ rgba(99, 60, 176, 0.5) ~ rgb(39%, 24%, 69%) ~ hsl(260, 49%, 46%) ~ cmyb(44%, 66%, 0%, 31%)'."\n".'Complementary: #89B03C'."\n".'Analogous: #9D3CB0, #B03C89',
        html => qr/background:#633cb0/
    ),
	'#dc5f3c' => test_zci(
		'Hex: #DC5F3C ~ rgba(220, 95, 60, 1) ~ rgb(86%, 37%, 24%) ~ hsl(13, 70%, 55%) ~ cmyb(0%, 57%, 73%, 14%)'."\n".'Complementary: #3BB9DB'."\n".'Analogous: #DBAE3B, #B9DB3B',
		html => qr/background:#dc5f3c/
	),
    # Queries to ignore.
    'bluishblack html' => undef,
    'HTML email'       => undef,
    'wield color'      => undef,
);

done_testing;


