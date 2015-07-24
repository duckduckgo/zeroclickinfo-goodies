#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'binary_logic';
zci is_cached => 1;

sub build_answer {
    my ($answer) = @_;
    
    return $answer, structured_answer => {
        id => 'binary_logic',
        name => 'Answer',
        data => {
            title => $answer,
            subtitle => 'Binary Logic'
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
    '4 xor 5' => test_zci(build_answer('1')),
    '4 ⊕ 5' => test_zci(build_answer('1')),
    '9489 xor 394 xor 9349 xor 39 xor 29 xor 4967 xor 3985' => test_zci(build_answer('7378')),
    '10 and 12' => test_zci(build_answer('8')),
    '10 ∧ 12' => test_zci(build_answer('8')),
    '52 or 100' => test_zci(build_answer('116')),
    '52 ∨ 100' => test_zci(build_answer('116')),
    '23 and (30 or 128)' => test_zci(build_answer('22')),
    '23 ∧ (30 ∨ 128)' => test_zci(build_answer('22')),
    '0x999 xor 0x589' => test_zci(build_answer('3088')),
    '0x999 ⊕ 0x589' => test_zci(build_answer('3088')),
    'not 1' => test_zci(build_answer('18446744073709551614')),
    '¬1' => test_zci(build_answer('18446744073709551614')),
    '3 and 2' => test_zci(build_answer('2')),
    '1 or 1234' => test_zci(build_answer('1235')),
    '34 or 100' => test_zci(build_answer('102')),
    '10 and (30 or 128)' => test_zci(build_answer('10')),
    '0x01 or not 0X100' => test_zci(build_answer('18446744073709551359')),
    '0x01 or 0x02' => test_zci(build_answer('3')),
    '0b01 or 0b10' => test_zci(build_answer('3')),
    '0B11 xor 0B10' => test_zci(build_answer('1')),
);

done_testing;