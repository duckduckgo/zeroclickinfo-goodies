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
    my($string_answer, $title, $subtitle) = @_;
    return $string_answer,
        structured_answer => {
            data => {
                title => $title,
                subtitle => $subtitle,
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
    'idn exämple.com' => build_test('Encoded IDN: xn--exmple-cua.com', 'xn--exmple-cua.com', 'exämple.com encoded'),
    'internationalize domain  exämple.com' => build_test('Encoded internationalized domain: xn--exmple-cua.com', 'xn--exmple-cua.com', 'exämple.com encoded'),
    'idn xn--exmple-cua.com' => build_test('Decoded IDN: exämple.com', 'exämple.com', 'xn--exmple-cua.com decoded'),
    'international domain xn--exmple-cua.com' => build_test('Decoded international domain: exämple.com', 'exämple.com', 'xn--exmple-cua.com decoded'),
    'internationalized domain xn--exmple-cua.com' => build_test('Decoded internationalized domain: exämple.com', 'exämple.com', 'xn--exmple-cua.com decoded'),
);

done_testing;
