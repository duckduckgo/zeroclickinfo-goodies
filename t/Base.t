#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'conversion';
zci is_cached   => 1;

sub build_structured_answer {
    my ($input, $from_base, $to_base, $output) = @_;
    return "$input in base $to_base is $output",
        structured_answer => {
            data => {
                title    => $output,
                subtitle => "From base $from_base to base $to_base: $input"
            },
            templates => {
                group => 'text'
            }
    };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw(DDG::Goodie::Base)],

    '255 in hex'     => build_test(255, 10, 16, 'FF'),
    '255 in base 16' => build_test(255, 10, 16, 'FF'),
    '42 in binary'   => build_test(42, 10, 2, '101010'),
    '42 in base 2'   => build_test(42, 10, 2, '101010'),
    '42 to hex'      => build_test(42, 10, 16, '2A'),
    '42 to octal'    => build_test(42, 10, 8, '52'),
    '10 in base 3'   => build_test(10, 10, 3, '101'),
    '18442240474082181119 to hex'     => build_test(18442240474082181119, 10, 16, 'FFEFFFFFFFFFFFFF'),
    '999999999999999999999999 to hex' => build_test("999999999999999999999999", 10, 16, 'D3C21BCECCEDA0FFFFFF'),
    'DDG in base 36 to decimal'       => build_test('DDG', 36, 10, '17332'),
    '0b1111 in base 10'               => build_test('1111', 2, 10, '15'),
    '81 in base 9 to base 3'          => build_test(81, 9, 3, '2201'),
    '1111 in binary as octal'         => build_test(1111, 2, 8, '17'),
    'FF in hex to decimal'            => build_test('FF', 16, 10, '255'),
    '0xFF in base 10'                 => build_test('FF', 16, 10, '255'),
    'BEEF as base 36 to hex'          => build_test('BEEF', 36, 16, '81DA7'),
    'HELLOWORLD as base 33 to dec'=> build_test('HELLOWORLD', 33, 10, '809608041709942'),
    '0xFF in binary to decimal' => undef,
    '0b1111 in hex as binary' => undef,
    '0xFF in binary hex as decimal' => undef,
    '0.01% in decimal' => undef
);

done_testing;
