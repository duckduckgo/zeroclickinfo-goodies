#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'idn';
zci is_cached => 1;

sub build_answer {
    my($answer) = @_;
    return $answer,
        structured_answer => {
            data => {
                title => $answer,
            },
            templates => {
                group => 'text',
            }
        };
}

sub build_test { test_zci(build_answer(@_)) }

ddg_goodie_test(
    [qw(
        DDG::Goodie::IDN
    )],
    'idn exämple.com' => build_test('Encoded IDN: xn--exmple-cua.com'),
    'internationalize domain  exämple.com' => build_test('Encoded internationalized domain: xn--exmple-cua.com'),
    'idn xn--exmple-cua.com' => build_test('Decoded IDN: exämple.com'),
    'international domain xn--exmple-cua.com' => build_test('Decoded international domain: exämple.com'),
    'internationalized domain xn--exmple-cua.com' => build_test('Decoded internationalized domain: exämple.com'),
);

done_testing;
