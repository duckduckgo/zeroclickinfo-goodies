#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'color_code';
zci is_cached => 1;

ddg_goodie_test([qw(
          DDG::Goodie::ColorCodes
          )
    ],
    'hex color code for cyan' => test_zci(
        'Hex: #00ffff ~ rgb(0, 255, 255) ~ rgb(0%, 100%, 100%) ~ hsl(180, 100%, 50%) ~ cmyb(100%, 0%, 0%, 0%)',
        html => qr/background:#00ffff/,
    ),
    'rgb(173,216,230)' => test_zci(
        'Hex: #add8e6 ~ rgb(173, 216, 230) ~ rgb(68%, 85%, 90%) ~ hsl(195, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%)',
        html => qr/background:#add8e6/,
    ),
    'hsl 194 0.53 0.79' => test_zci(
        'Hex: #add8e5 ~ rgb(173, 216, 229) ~ rgb(68%, 85%, 90%) ~ hsl(194, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%)',
        html => qr/background:#add8e5/,
    ),
    'cmyk(0.12, 0, 0, 0)' => test_zci(
        'Hex: #e0ffff ~ rgb(224, 255, 255) ~ rgb(88%, 100%, 100%) ~ hsl(180, 100%, 94%) ~ cmyb(12%, 0%, 0%, 0%)',
        html => qr/background:#e0ffff/,
    ),
    '#00ff00' => test_zci(
        'Hex: #00ff00 ~ rgb(0, 255, 0) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%)',
        html => qr/background:#00ff00/,
    ),
    '#0f0' => test_zci(
        'Hex: #00ff00 ~ rgb(0, 255, 0) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%)',
        html => qr/background:#00ff00/,
    ),
    'inverse of the color red' => test_zci(
        'Hex: #00ffff ~ rgb(0, 255, 255) ~ rgb(0%, 100%, 100%) ~ hsl(180, 100%, 50%) ~ cmyb(100%, 0%, 0%, 0%)',
        html => qr/background:#00ffff/,
    ),
    'rgb(0 255 0)\'s inverse' => test_zci(
        'Hex: #ff00ff ~ rgb(255, 0, 255) ~ rgb(100%, 0%, 100%) ~ hsl(300, 100%, 50%) ~ cmyb(0%, 100%, 0%, 0%)',
        html => qr/background:#ff00ff/,
    ),
    'html bluishblack' => test_zci(
        'Hex: #202428 ~ rgb(32, 36, 40) ~ rgb(13%, 14%, 16%) ~ hsl(210, 11%, 14%) ~ cmyb(20%, 10%, 0%, 84%)',
        html => qr/background:#202428/,
    ),
    # Single full HTML check.
    'red html code' => test_zci(
        'Hex: #ff0000 ~ rgb(255, 0, 0) ~ rgb(100%, 0%, 0%) ~ hsl(0, 100%, 50%) ~ cmyb(0%, 100%, 100%, 0%)',
        html =>
          qq(<div class="zci--color-codes"><div class="colorcodesbox" style="background:#ff0000"></div>Hex: #ff0000 &middot; rgb(255, 0, 0) &middot; rgb(100%, 0%, 0%) <br> hsl(0, 100%, 50%) &middot; cmyb(0%, 100%, 100%, 0%) &middot; [<a href='http://labs.tineye.com/multicolr#colors=ff0000;weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/ff0000' title='Tints, information and similar colors on color-hex.com'>Info</a>]</div>),
    ),
    # Queries to ignore.
    'bluishblack html' => undef,
    'HTML email'       => undef,
    'wield color'      => undef,
);

done_testing;


