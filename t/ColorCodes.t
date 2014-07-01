#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'color_code';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::ColorCodes
	)],
	'hex color code for cyan' => test_zci(
		'Hex: #00ffff ~ rgb(0, 255, 255) ~ rgb(0%, 100%, 100%) ~ hsl(180, 100%, 50%) ~ cmyb(100%, 0%, 0%, 0%)', 
		html => qq(<div style="background:#00ffff;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #00ffff ~ rgb(0, 255, 255) ~ rgb(0%, 100%, 100%) ~ hsl(180, 100%, 50%) ~ cmyb(100%, 0%, 0%, 0%) [<a href='http://labs.tineye.com/multicolr#colors=00ffff;weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/00ffff' title='Tints, information and similar colors on color-hex.com'>Info</a>])
	),
	'rgb(173,216,230)' => test_zci(
		'Hex: #add8e6 ~ rgb(173, 216, 230) ~ rgb(68%, 85%, 90%) ~ hsl(195, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%)', 
		html => qq(<div style="background:#add8e6;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #add8e6 ~ rgb(173, 216, 230) ~ rgb(68%, 85%, 90%) ~ hsl(195, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%) [<a href='http://labs.tineye.com/multicolr#colors=add8e6;weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/add8e6' title='Tints, information and similar colors on color-hex.com'>Info</a>])
	),
	'hsl 194 0.53 0.79' => test_zci(
		'Hex: #add8e5 ~ rgb(173, 216, 229) ~ rgb(68%, 85%, 90%) ~ hsl(194, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%)', 
		html => qq(<div style="background:#add8e5;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #add8e5 ~ rgb(173, 216, 229) ~ rgb(68%, 85%, 90%) ~ hsl(194, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%) [<a href='http://labs.tineye.com/multicolr#colors=add8e5;weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/add8e5' title='Tints, information and similar colors on color-hex.com'>Info</a>])
	),
    'cmyk(0.12, 0, 0, 0)' => test_zci(
    	'Hex: #e0ffff ~ rgb(224, 255, 255) ~ rgb(88%, 100%, 100%) ~ hsl(180, 100%, 94%) ~ cmyb(12%, 0%, 0%, 0%)', 
    	html => qq(<div style="background:#e0ffff;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #e0ffff ~ rgb(224, 255, 255) ~ rgb(88%, 100%, 100%) ~ hsl(180, 100%, 94%) ~ cmyb(12%, 0%, 0%, 0%) [<a href='http://labs.tineye.com/multicolr#colors=e0ffff;weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/e0ffff' title='Tints, information and similar colors on color-hex.com'>Info</a>])
    ),
    '#00ff00' => test_zci(
    	'Hex: #00ff00 ~ rgb(0, 255, 0) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%)', 
    	html => qq(<div style="background:#00ff00;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #00ff00 ~ rgb(0, 255, 0) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%) [<a href='http://labs.tineye.com/multicolr#colors=00ff00;weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/00ff00' title='Tints, information and similar colors on color-hex.com'>Info</a>])
    ),
    '#0f0' => test_zci(
    	'Hex: #00ff00 ~ rgb(0, 255, 0) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%)', 
    	html => qq(<div style="background:#00ff00;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #00ff00 ~ rgb(0, 255, 0) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%) [<a href='http://labs.tineye.com/multicolr#colors=00ff00;weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/00ff00' title='Tints, information and similar colors on color-hex.com'>Info</a>])
    ),
    'inverse of the color red' => test_zci(
        'Hex: #00ffff ~ rgb(0, 255, 255) ~ rgb(0%, 100%, 100%) ~ hsl(180, 100%, 50%) ~ cmyb(100%, 0%, 0%, 0%)',
        html => qq(<div style="background:#00ffff;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #00ffff ~ rgb(0, 255, 255) ~ rgb(0%, 100%, 100%) ~ hsl(180, 100%, 50%) ~ cmyb(100%, 0%, 0%, 0%) [<a href='http://labs.tineye.com/multicolr#colors=00ffff;weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/00ffff' title='Tints, information and similar colors on color-hex.com'>Info</a>]),
    ),
    'rgb(0 255 0)\'s inverse' => test_zci(
        'Hex: #ff00ff ~ rgb(255, 0, 255) ~ rgb(100%, 0%, 100%) ~ hsl(300, 100%, 50%) ~ cmyb(0%, 100%, 0%, 0%)',
        html => qq(<div style="background:#ff00ff;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #ff00ff ~ rgb(255, 0, 255) ~ rgb(100%, 0%, 100%) ~ hsl(300, 100%, 50%) ~ cmyb(0%, 100%, 0%, 0%) [<a href='http://labs.tineye.com/multicolr#colors=ff00ff;weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/ff00ff' title='Tints, information and similar colors on color-hex.com'>Info</a>]),
    ),
    'html bluishblack' => test_zci(
        'Hex: #202428 ~ rgb(32, 36, 40) ~ rgb(13%, 14%, 16%) ~ hsl(210, 11%, 14%) ~ cmyb(20%, 10%, 0%, 84%)',
        html => qq(<div style="background:#202428;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #202428 ~ rgb(32, 36, 40) ~ rgb(13%, 14%, 16%) ~ hsl(210, 11%, 14%) ~ cmyb(20%, 10%, 0%, 84%) [<a href='http://labs.tineye.com/multicolr#colors=202428;weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/202428' title='Tints, information and similar colors on color-hex.com'>Info</a>]),
    ),
    'bluishblack html' => undef,
    'HTML email'       => undef,
    'wield color'      => undef,
);

done_testing;


