#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'color_code';
zci is_cached => 1;

my @green_args = (
    'Hex: #00FF00 ~ RGBA(0, 255, 0, 1) ~ RGB(0%, 100%, 0%) ~ HSL(120, 100%, 50%) ~ CMYB(100%, 0%, 100%, 0%)'."\n".'Complementary: #FF00FF'."\n".'Analogous: #00FF80, #80FF00',
    html => qr/background:#00ff00/
);

ddg_goodie_test(
	[qw(DDG::Goodie::ColorCodes)],
    'hex color code for cyan' => test_zci(
        'Hex: #00FFFF ~ RGBA(0, 255, 255, 1) ~ RGB(0%, 100%, 100%) ~ HSL(180, 100%, 50%) ~ CMYB(100%, 0%, 0%, 0%)'."\n".'Complementary: #FF0000'."\n".'Analogous: #0080FF, #00FF80',
        html => qr/background:#00ffff/,
    ),
    'RGB(173,216,230)' => test_zci(
        'Hex: #ADD8E6 ~ RGBA(173, 216, 230, 1) ~ RGB(68%, 85%, 90%) ~ HSL(195, 53%, 79%) ~ CMYB(25%, 6%, 0%, 10%)'."\n".'Complementary: #E6BAAC'."\n".'Analogous: #ACBAE6, #ACE6D7',
        html => qr/background:#add8e6/,
    ),
    'hsl 194 0.53 0.79' => test_zci(
        'Hex: #ADD8E5 ~ RGBA(173, 216, 229, 1) ~ RGB(68%, 85%, 90%) ~ HSL(194, 53%, 79%) ~ CMYB(25%, 6%, 0%, 10%)'."\n".'Complementary: #E6BBAE'."\n".'Analogous: #AEBDE6, #AEE6D7',
        html => qr/background:#add8e5/,
    ),
    'cmyk(0.12, 0, 0, 0)' => test_zci(
        'Hex: #E0FFFF ~ RGBA(224, 255, 255, 1) ~ RGB(88%, 100%, 100%) ~ HSL(180, 100%, 94%) ~ CMYB(12%, 0%, 0%, 0%)'."\n".'Complementary: #FFE0E0'."\n".'Analogous: #E0F0FF, #E0FFF0',
        html => qr/background:#e0ffff/,
    ),
    '#00ff00' => test_zci(@green_args),
    '#0f0' => test_zci(@green_args),
    '#0f0 to rgb' => test_zci(@green_args),
    '#0f0 to cmyk' => test_zci(@green_args),
    'inverse of the color red' => test_zci(
        'Hex: #00FFFF ~ RGBA(0, 255, 255, 1) ~ RGB(0%, 100%, 100%) ~ HSL(180, 100%, 50%) ~ CMYB(100%, 0%, 0%, 0%)'."\n".'Complementary: #FF0000'."\n".'Analogous: #0080FF, #00FF80',
        html => qr/background:#00ffff/,
    ),
    'RGB(0 255 0)\'s inverse' => test_zci(
        'Hex: #FF00FF ~ RGBA(255, 0, 255, 1) ~ RGB(100%, 0%, 100%) ~ HSL(300, 100%, 50%) ~ CMYB(0%, 100%, 0%, 0%)'."\n".'Complementary: #00FF00'."\n".'Analogous: #FF0080, #8000FF',
        html => qr/background:#ff00ff/,
    ),
    'html bluishblack' => test_zci(
        'Hex: #202428 ~ RGBA(32, 36, 40, 1) ~ RGB(13%, 14%, 16%) ~ HSL(210, 11%, 14%) ~ CMYB(20%, 10%, 0%, 84%)'."\n".'Complementary: #292521'."\n".'Analogous: #212129, #212929',
        html => qr/background:#202428/,
    ),
    # Single full HTML check.
    'red html code' => test_zci(
        'Hex: #FF0000 ~ RGBA(255, 0, 0, 1) ~ RGB(100%, 0%, 0%) ~ HSL(0, 100%, 50%) ~ CMYB(0%, 100%, 100%, 0%)'."\n".'Complementary: #00FFFF'."\n".'Analogous: #FF8000, #FF0080',
        html => qq(<div class="zci--color-codes"><a href="/?q=color%20picker%20%23ff0000" class="colorcodesbox circle" style="background:#ff0000"></a><div class='column1 tx-clr--dk2'><p class='hex tx-clr--dk zci__caption'>Hex: #FF0000</p><p class='no_vspace'>RGBA(255, 0, 0, 1)</p><p class='no_vspace'>HSL(0, 100%, 50%)</p><p class='no_vspace'>CMYB(0%, 100%, 100%, 0%)</p><p><a href='http://labs.tineye.com/multicolr/#colors=ff0000;weights=100;' class='tx-clr--dk2'>Images</a><span class='separator'> | </span><a href='http://www.color-hex.com/color/ff0000' title='Tints, information and similar colors on color-hex.com' class='tx-clr--dk2'>Info</a><span class='separator'> | </span><a href='/?q=color%20picker%20%23ff0000' class='tx-clr--dk2'>Picker</a></p></div><div class='column2 tx-clr--dk2'><div class='complementary'><div class='cols_column'><a href='/?q=color%20picker%20%2300FFFF' class='mini-color circle' style='background: #00FFFF'></a></div><div class='desc_column'><p class='no_vspace'>Complementary #:</p><p class='no_vspace'><a onclick='document.x.q.value="#00FFFF";document.x.q.focus();' href='javascript:' class='tx-clr--lt'>00FFFF</a></p></div></div><div><div class='cols_column'><a href='/?q=color%20picker%20%23ff8000' class='mini-color circle' style='background: #ff8000'> </a><a href='/?q=color%20picker%20%23ff0080' class='mini-color circle' style='background: #ff0080'> </a></div><div class='desc_column'><p class='no_vspace'>Analogous #:</p><p class='no_vspace'><a onclick='document.x.q.value="#FF8000";document.x.q.focus();' href='javascript:' class='tx-clr--lt'>FF8000</a>, <a onclick='document.x.q.value="#FF0080";document.x.q.focus();' href='javascript:' class='tx-clr--lt'>FF0080</a></p></div></div></div></div>)
    ),
    'RGBA(99,60,176,0.5)' => test_zci(
        'Hex: #633CB0 ~ RGBA(99, 60, 176, 0.5) ~ RGB(39%, 24%, 69%) ~ HSL(260, 49%, 46%) ~ CMYB(44%, 66%, 0%, 31%)'."\n".'Complementary: #89B03C'."\n".'Analogous: #9D3CB0, #3C4FB0',
        html => qr/background:#633cb0/
    ),
	'#dc5f3c' => test_zci(
		'Hex: #DC5F3C ~ RGBA(220, 95, 60, 1) ~ RGB(86%, 37%, 24%) ~ HSL(13, 70%, 55%) ~ CMYB(0%, 57%, 73%, 14%)'."\n".'Complementary: #3BB9DB'."\n".'Analogous: #DBAE3B, #DB3B69',
		html => qr/background:#dc5f3c/
	),
	#Colours with no hue shouldn't have complements or analogs
    '#000000' => test_zci(
        'Hex: #000000 ~ RGBA(0, 0, 0, 1) ~ RGB(0%, 0%, 0%) ~ HSL(0, 0%, 0%) ~ CMYB(0%, 0%, 0%, 100%)',
        html => qq(<div class="zci--color-codes"><a href="/?q=color%20picker%20%23000000" class="colorcodesbox circle" style="background:#000000"></a><div class='column1 tx-clr--dk2'><p class='hex tx-clr--dk zci__caption'>Hex: #000000</p><p class='no_vspace'>RGBA(0, 0, 0, 1)</p><p class='no_vspace'>HSL(0, 0%, 0%)</p><p class='no_vspace'>CMYB(0%, 0%, 0%, 100%)</p><p><a href='http://labs.tineye.com/multicolr/#colors=000000;weights=100;' class='tx-clr--dk2'>Images</a><span class='separator'> | </span><a href='http://www.color-hex.com/color/000000' title='Tints, information and similar colors on color-hex.com' class='tx-clr--dk2'>Info</a><span class='separator'> | </span><a href='/?q=color%20picker%20%23000000' class='tx-clr--dk2'>Picker</a></p></div></div>)
    ),
	'#FFFFFF' => test_zci(
        'Hex: #FFFFFF ~ RGBA(255, 255, 255, 1) ~ RGB(100%, 100%, 100%) ~ HSL(0, 0%, 100%) ~ CMYB(0%, 0%, 0%, 0%)',
        html => qq(<div class="zci--color-codes"><a href="/?q=color%20picker%20%23ffffff" class="colorcodesbox circle" style="background:#ffffff"></a><div class='column1 tx-clr--dk2'><p class='hex tx-clr--dk zci__caption'>Hex: #FFFFFF</p><p class='no_vspace'>RGBA(255, 255, 255, 1)</p><p class='no_vspace'>HSL(0, 0%, 100%)</p><p class='no_vspace'>CMYB(0%, 0%, 0%, 0%)</p><p><a href='http://labs.tineye.com/multicolr/#colors=ffffff;weights=100;' class='tx-clr--dk2'>Images</a><span class='separator'> | </span><a href='http://www.color-hex.com/color/ffffff' title='Tints, information and similar colors on color-hex.com' class='tx-clr--dk2'>Info</a><span class='separator'> | </span><a href='/?q=color%20picker%20%23ffffff' class='tx-clr--dk2'>Picker</a></p></div></div>)
    ),
    # Queries to ignore.
    'bluishblack html' => undef,
    'HTML email'       => undef,
    'wield color'      => undef,
);

done_testing;


