#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'binary_logic';
# zci is_cached => 1;

sub bl_test {
    my $head = $_[0];
    my $text = $_[1];
    
    test_zci($text, 
             html => "<div>Result: <b>" . $text . "</b></div>", 
             heading => "Binary Logic: '" . $head . "'");
}

ddg_goodie_test(
    [qw(
                DDG::Goodie::BinaryLogic
        )],
    '4 xor 5' => bl_test('4 xor 5', '1'),
    '4 ⊕ 5' => bl_test('4 ⊕ 5', '1'),

    '9489 xor 394 xor 9349 xor 39 xor 29 xor 4967 xor 3985' => 
      bl_test('9489 xor 394 xor 9349 xor 39 xor 29 xor 4967 xor 3985', '7378'),

    '10 and 12' => bl_test('10 and 12', '8'),
    '10 ∧ 12' => bl_test('10 ∧ 12', '8'),

    '52 or 100' => bl_test('52 or 100', '116'),
    '52 ∨ 100' => bl_test('52 ∨ 100', '116'),

    '23 and (30 or 128)' => bl_test('23 and (30 or 128)', '22'),
    '23 ∧ (30 ∨ 128)' => bl_test('23 ∧ (30 ∨ 128)', '22'),

    '0x999 xor 0x589' => bl_test('0x999 xor 0x589', '3088'),
    '0x999 ⊕ 0x589' => bl_test('0x999 ⊕ 0x589', '3088'),

    'not 1' => bl_test('not 1', '18446744073709551614'),
    '¬1' => bl_test('¬1', '18446744073709551614'),
);

done_testing;
