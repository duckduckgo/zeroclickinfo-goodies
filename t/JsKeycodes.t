#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => 'jskeycodes';

ddg_goodie_test(
        [qw(
                DDG::Goodie::JsKeycodes
        )],
        'js charCode backspace' => test_zci('Keycode for backspace: 8 (JavaScript)',
                html => qr:<tr><td class='c1'><b>backspace</b></td>:),
        'javascript charcode tab' => test_zci('Keycode for tab: 9 (JavaScript)',
                html => qr:<tr><td class='c1'><b>tab</b></td>:),
        'JavaScript keycode enter' => test_zci('Keycode for enter: 13 (JavaScript)',
                html => qr:<tr><td class='c1'><b>enter</b></td>:),
        'js keyCode shift' => test_zci('Keycode for shift: 16 (JavaScript)',
                html => qr:<tr><td class='c1'><b>shift</b></td>:),
        'js ctrl charcode' => test_zci('Keycode for ctrl: 17 (JavaScript)',
                html => qr:<tr><td class='c1'><b>ctrl</b></td>:),
        'js alt charCode' => test_zci('Keycode for alt: 18 (JavaScript)',
                html => qr:<tr><td class='c1'><b>alt</b></td>:),
        'js pause keycode' => test_zci('Keycode for pause: 19 (JavaScript)',
                html => qr:<tr><td class='c1'><b>pause</b></td>:),
        'js break keyCode' => test_zci('Keycode for break: 19 (JavaScript)',
                html => qr:<tr><td class='c1'><b>break</b></td>:),
        'js charCode 0' => test_zci('Keycode for 0: 48 (JavaScript)',
                html => qr:<tr><td class='c1'><b>0</b></td>:),
        'js charCode 3' => test_zci('Keycode for 3: 51 (JavaScript)',
                html => qr:<tr><td class='c1'><b>3</b></td>:),
        'js 6 charCode' => test_zci('Keycode for 6: 54 (JavaScript)',
                html => qr:<tr><td class='c1'><b>6</b></td>:),
        'js charcode 8' => test_zci('Keycode for 8: 56 (JavaScript)',
                html => qr:<tr><td class='c1'><b>8</b></td>:),
        'js a charCode' => test_zci('Keycode for a: 65 (JavaScript)',
                html => qr:<tr><td class='c1'><b>a</b></td>:),
        'js charCode A' => test_zci('Keycode for a: 65 (JavaScript)',
                html => qr:<tr><td class='c1'><b>a</b></td>:),
        'js charcode H' => test_zci('Keycode for h: 73 (JavaScript)',
                html => qr:<tr><td class='c1'><b>h</b></td>:),
        'js charcode h' => test_zci('Keycode for h: 73 (JavaScript)',
                html => qr:<tr><td class='c1'><b>h</b></td>:),
        'js p charcode' => test_zci('Keycode for p: 80 (JavaScript)',
                html => qr:<tr><td class='c1'><b>p</b></td>:),
        'js charcode P' => test_zci('Keycode for p: 80 (JavaScript)',
                html => qr:<tr><td class='c1'><b>p</b></td>:),
        'js charCode f1' => test_zci('Keycode for f1: 112 (JavaScript)',
                html => qr:<tr><td class='c1'><b>f1</b></td>:),
        'js charcode f4' => test_zci('Keycode for f4: 115 (JavaScript)',
                html => qr:<tr><td class='c1'><b>f4</b></td>:),
        'js numpad 1 keyCode' => test_zci('Keycode for numpad 1: 97 (JavaScript)',
                html => qr:<tr><td class='c1'><b>numpad 1</b></td>:),
        'js charCode num lock' => test_zci('Keycode for num lock: 144 (JavaScript)',
                html => qr:<tr><td class='c1'><b>num lock</b></td>:),
        'js scroll lock charcode ' => test_zci('Keycode for scroll lock: 145 (JavaScript)',
                html => qr:<tr><td class='c1'><b>scroll lock</b></td>:),
        'js charcode ;' => test_zci('Keycode for ;: 186 (JavaScript)',
                html => qr:<tr><td class='c1'><b>;</b></td>:),
        'js keycode =' => test_zci('Keycode for =: 187 (JavaScript)',
                html => qr:<tr><td class='c1'><b>=</b></td>:),
        'js keyCode \\' => test_zci('Keycode for \: 220 (JavaScript)',
                html => qr:<tr><td class='c1'><b>\\</b></td>:),
        'js charCode quote' => test_zci('Keycode for quote: 222 (JavaScript)',
                html => qr:<tr><td class='c1'><b>quote</b></td>:),
        'js charcode (' => test_zci('Keycode for (: 219 (JavaScript)',
                html => qr:<tr><td class='c1'><b>\(</b></td>:),
);

done_testing;
