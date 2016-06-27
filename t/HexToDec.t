#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'hex_to_dec';
zci is_cached   => 1;

sub build_test
{
    my ($text, $title, $subtitle) = @_;

    return test_zci($text, structured_answer => {
       data => {
           title => $title,
           subtitle => "Hex to decimal: $subtitle"
       },
       templates => {
           group => 'text'
       }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::HexToDec )],
    '0xd1038d2e07b42569' => build_test(
        'd1038d2e07b42569 base 16 = 15061036807694329193 base 10',
        15061036807694329193,
        '0xd1038d2e07b42569'
    ),
    '0x44696f21' => build_test(
        '44696f21 base 16 = 1147760417 base 10', 
        1147760417,
        '0x44696f21'
    ),
    '0xffffffffffffffffffffff' => build_test(
        'ffffffffffffffffffffff base 16 = 309485009821345068724781055 base 10', 
        "309485009821345068724781055",
        '0xffffffffffffffffffffff'
    ),
    '0xff in decimal' => build_test('ff base 16 = 255 base 10', "255", '0xff'),
    '0xff hex to dec' => build_test('ff base 16 = 255 base 10', "255", '0xff'),
    '0xff as base 10' => build_test('ff base 16 = 255 base 10', "255", '0xff'),
    '0xff in base-10' => build_test('ff base 16 = 255 base 10', "255", '0xff'),
    '0xff hex to base10' => build_test('ff base 16 = 255 base 10', "255", '0xff'),
    '0x44696f2Z'       => undef,
    'ascii 0x74657374' => undef,
    '0x255 hex'        => undef,
    '0x255 hex dec'    => undef,
    '0x255 to'         => undef,
    '255 as base 10'   => undef,
    'as decimal'       => undef,
    'hex to decimal'   => undef,
    'base10'           => undef,
    '0x01 + 0x02'      => undef,
    '20x40 in dec'     => undef,
    '0x'               => undef,
    'hex'              => undef,
    'to'               => undef,
);

done_testing;
