#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'binary_logic';
zci is_cached => 1;

sub build_answer {
    my ($answer, $sub) = @_;
    $sub = '' unless $sub;

    return $answer, structured_answer => {
        data => {
            title => $answer,
            subtitle => "Bitwise Operation: $sub"
        },
        templates => {
            group => 'text',
            moreAt => 0
        }
    }
}

ddg_goodie_test(
    [qw(
        DDG::Goodie::BinaryLogic
    )],
    '4 xor 5' => test_zci(build_answer('1', sprintf "%b XOR %b", 4, 5)),
    '4 XOR 5' => test_zci(build_answer('1', sprintf "%b XOR %b", 4, 5)),
    '4 ⊕ 5' => test_zci(build_answer('1', sprintf "%b XOR %b", 4, 5)),
    '4⊕5' => test_zci(build_answer('1', sprintf "%b XOR %b", 4, 5)),
    '9489 xor 394 xor 9349 xor 39 xor 29 xor 4967 xor 3985' =>
        test_zci(build_answer('7378', sprintf "%b XOR %b XOR %b XOR %b XOR %b XOR %b XOR %b", 9489, 394, 9349, 39, 29, 4967, 3985)),
    '10 and 12' => test_zci(build_answer('8', sprintf "%b AND %b", 10, 12)),
    '10 AND 12' => test_zci(build_answer('8', sprintf "%b AND %b", 10, 12)),
    '10 ∧ 12' => test_zci(build_answer('8', sprintf "%b AND %b", 10, 12)),
    '10∧12' => test_zci(build_answer('8', sprintf "%b AND %b", 10, 12)),
    '52 or 100' => test_zci(build_answer('116', sprintf "%b OR %b", 52, 100)),
    '52 OR 100' => test_zci(build_answer('116', sprintf "%b OR %b", 52, 100)),
    '52 ∨ 100' => test_zci(build_answer('116', sprintf "%b OR %b", 52, 100)),
    '52∨100' => test_zci(build_answer('116', sprintf "%b OR %b", 52, 100)),
    '23 and (30 or 128)' => test_zci(build_answer('22', sprintf "%b AND (%b OR %b)", 23, 30, 128)),
    '23 AND (30 OR 128)' => test_zci(build_answer('22', sprintf "%b AND (%b OR %b)", 23, 30, 128)),
    '23 ∧ (30 ∨ 128)' => test_zci(build_answer('22', sprintf "%b AND (%b OR %b)", 23, 30, 128)),
    '23∧(30∨128)' => test_zci(build_answer('22', sprintf "%b AND (%b OR %b)", 23, 30, 128)),
    '0x999 xor 0x589' => test_zci(build_answer('3088', sprintf "%b XOR %b", hex(999), hex(589))),
    '0x999 ⊕ 0x589' => test_zci(build_answer('3088', sprintf "%b XOR %b", hex(999), hex(589))),
    'not 1' => test_zci(build_answer('18446744073709551614', sprintf "NOT %b", 1)),
    'NOT 1' => test_zci(build_answer('18446744073709551614', sprintf "NOT %b", 1)),
    '¬1' => test_zci(build_answer('18446744073709551614', sprintf "NOT %b", 1)),
    '3 and 2' => test_zci(build_answer('2', sprintf "%b AND %b", 3, 2)),
    '1 or 1234' => test_zci(build_answer('1235', sprintf "%b OR %b", 1, 1234)),
    '34 or 100' => test_zci(build_answer('102', sprintf "%b OR %b", 34, 100)),
    '10 and (30 or 128)' => test_zci(build_answer('10', sprintf "%b AND (%b OR %b)", 10, 30, 128)),
    '0x01 or not 0X100' => test_zci(build_answer('18446744073709551359', sprintf "%b OR NOT %b", hex(1), hex(100))),
    '0x01 OR NOT 0X100' => test_zci(build_answer('18446744073709551359', sprintf "%b OR NOT %b", hex(1), hex(100))),
    '0x01 or 0x02' => test_zci(build_answer('3', sprintf "%b OR %b", hex(1), hex(2))),
    '0b01 or 0b10' => test_zci(build_answer('3', sprintf "01 OR 10")),
    '0B11 xor 0B10' => test_zci(build_answer('1', sprintf "11 XOR 10")),

    # failing tests
    'one and two' => undef,
    'sentence containing and then words' => undef,
    'sentence containing not then words' => undef,
    'sentence containing or then words' => undef,
    'not words or word and number' => undef,
    'what do number and letter codes in a lens name mean' => undef
);

done_testing;
