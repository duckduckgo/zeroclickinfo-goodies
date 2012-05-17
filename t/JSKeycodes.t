#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => 'jskeycodes';

ddg_goodie_test(
        [qw(
                DDG::Goodie::JSKeycodes
        )],
        'charCode backspace' => test_zci('Keycode: 8 (JavaScript)'),
        'charcode tab' => test_zci('Keycode: 9 (JavaScript)'),
        'keycode enter' => test_zci('Keycode: 13 (JavaScript)'),
        'keyCode shift' => test_zci('Keycode: 16 (JavaScript)'),
        'ctrl charcode' => test_zci('Keycode: 17 (JavaScript)'),
        'alt charCode' => test_zci('Keycode: 18 (JavaScript)'),
        'pause keycode' => test_zci('Keycode: 19 (JavaScript)'),
        'break keyCode' => test_zci('Keycode: 19 (JavaScript)'),
        'charCode 0' => test_zci('Keycode: 48 (JavaScript)'),,
        'charCode 3' => test_zci('Keycode: 51 (JavaScript)'),
        '6 charCode' => test_zci('Keycode: 54 (JavaScript)'),
        'charcode 8' => test_zci('Keycode: 56 (JavaScript)'),
        'a charCode' => test_zci('Keycode: 65 (JavaScript)'),
        'charCode A' => test_zci('Keycode: 65 (JavaScript)'),
        'charcode H' => test_zci('Keycode: 73 (JavaScript)'),
        'charcode h' => test_zci('Keycode: 73 (JavaScript)'),
        'p charcode' => test_zci('Keycode: 80 (JavaScript)'),
        'charcode P' => test_zci('Keycode: 80 (JavaScript)'),
        'charCode f1' => test_zci('Keycode: 112 (JavaScript)'),
        'charcode f4' => test_zci('Keycode: 115 (JavaScript)'),
        'f6 charCode' => test_zci('Keycode: 117 (JavaScript)'),
        'f7 charcode' => test_zci('Keycode: 118 (JavaScript)'),
        'f12 keycode' => test_zci('Keycode: 123 (JavaScript)'),
        'numpad 1 keyCode' => test_zci('Keycode: 97 (JavaScript)'),
        'charCode numpad 3' => test_zci('Keycode: 98 (JavaScript)'),
        'keycode numpad 8' => test_zci('Keycode: 104 (JavaScript)'),
        'charcode numpad 9' => test_zci('Keycode: 105 (JavaScript)'),
        'charCode num lock' => test_zci('Keycode: 144 (JavaScript)'),
        'scroll lock charcode ' => test_zci('Keycode: 145 (JavaScript)'),
        'charcode ;' => test_zci('Keycode: 186 (JavaScript)'),
        'keycode =' => test_zci('Keycode: 187 (JavaScript)'),
        'keyCode \\' => test_zci('Keycode: 220 (JavaScript)'),
        'charCode quote' => test_zci('Keycode: 222 (JavaScript)'),
        'charcode (' => test_zci('Keycode: 219 (JavaScript)'),
        ') keycode' => test_zci('Keycode: 221 (JavaScript)'),
);

done_testing;