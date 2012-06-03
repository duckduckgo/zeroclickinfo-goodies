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
	'hex color code for cyan' => test_zci('Hex: #00ffff ~ rgb(0, 255, 255) ~ rgb(0%, 100%, 100%) ~ hsl(180, 100%, 50%) ~ cmyb(100%, 0%, 0%, 0%)', html => '<div style="background:#00ffff;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #00ffff ~ rgb(0, 255, 255) ~ rgb(0%, 100%, 100%) ~ hsl(180, 100%, 50%) ~ cmyb(100%, 0%, 0%, 0%)'),
	'rgb(173,216,230)' => test_zci('Hex: #add8e6 ~ rgb(173, 216, 230) ~ rgb(68%, 85%, 90%) ~ hsl(195, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%)', html => '<div style="background:#add8e6;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #add8e6 ~ rgb(173, 216, 230) ~ rgb(68%, 85%, 90%) ~ hsl(195, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%)'),
	'hsl 194 0.53 0.79' => test_zci('Hex: #add8e5 ~ rgb(173, 216, 229) ~ rgb(68%, 85%, 90%) ~ hsl(194, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%)', html => '<div style="background:#add8e5;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #add8e5 ~ rgb(173, 216, 229) ~ rgb(68%, 85%, 90%) ~ hsl(194, 53%, 79%) ~ cmyb(25%, 6%, 0%, 10%)'),
    'cmyk(0.12, 0, 0, 0)' => test_zci('Hex: #e0ffff ~ rgb(224, 255, 255) ~ rgb(88%, 100%, 100%) ~ hsl(180, 100%, 94%) ~ cmyb(12%, 0%, 0%, 0%)', html => '<div style="background:#e0ffff;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #e0ffff ~ rgb(224, 255, 255) ~ rgb(88%, 100%, 100%) ~ hsl(180, 100%, 94%) ~ cmyb(12%, 0%, 0%, 0%)'),
    '#00ff00' => test_zci('Hex: #00ff00 ~ rgb(0, 255, 0) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%)', html => '<div style="background:#00ff00;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #00ff00 ~ rgb(0, 255, 0) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%)'),
    '#0f0' => test_zci('Hex: #00ff00 ~ rgb(0, 255, 0) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%)', html => '<div style="background:#00ff00;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #00ff00 ~ rgb(0, 255, 0) ~ rgb(0%, 100%, 0%) ~ hsl(120, 100%, 50%) ~ cmyb(100%, 0%, 100%, 0%)'),
);

done_testing;


