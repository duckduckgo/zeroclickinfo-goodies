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
	'hex color code for cyan' => test_zci("Hex: #00ffff, Red: 0, Green: 255, Blue: 255 ~ Hue: 180, Saturation: 1.00, Value: 0.50 ~ Cyan: 1.00, Magenta: 0.00, Yellow: 0.00, Black: 0.00", html => '<div style="background:#00ffff;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #00ffff, Red: 0, Green: 255, Blue: 255 ~ Hue: 180, Saturation: 1.00, Value: 0.50 ~ Cyan: 1.00, Magenta: 0.00, Yellow: 0.00, Black: 0.00'),
	'rgb(173,216,230)' => test_zci("Hex: #add8e6, Red: 173, Green: 216, Blue: 230 ~ Hue: 194, Saturation: 0.53, Value: 0.79 ~ Cyan: 0.25, Magenta: 0.06, Yellow: 0.00, Black: 0.10", html => '<div style="background:#add8e6;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #add8e6, Red: 173, Green: 216, Blue: 230 ~ Hue: 194, Saturation: 0.53, Value: 0.79 ~ Cyan: 0.25, Magenta: 0.06, Yellow: 0.00, Black: 0.10'),
	'hsl 194 0.53 0.79' => test_zci("Hex: #add8e5, Red: 173, Green: 216, Blue: 229 ~ Hue: 194, Saturation: 0.53, Value: 0.79 ~ Cyan: 0.25, Magenta: 0.06, Yellow: 0.00, Black: 0.10", html    => '<div style="background:#add8e5;border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>Hex: #add8e5, Red: 173, Green: 216, Blue: 229 ~ Hue: 194, Saturation: 0.53, Value: 0.79 ~ Cyan: 0.25, Magenta: 0.06, Yellow: 0.00, Black: 0.10'),
);

done_testing;


