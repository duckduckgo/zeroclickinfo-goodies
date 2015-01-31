#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'base64_conversion';
zci is_cached   => 1;

my @foo = (
    'Base64 encoded: Zm9v',
    structured_answer => {
        input     => ['foo'],
        operation => 'Base64 encode',
        result    => 'Zm9v'
    });
my @this_text = (
    'Base64 decoded: this text',
    structured_answer => {
        input     => ['dGhpcyB0ZXh0'],
        operation => 'Base64 decode',
        result    => 'this text'
    });

ddg_goodie_test(
    [qw( DDG::Goodie::Base64)],
    'base64 encode foo'       => test_zci(@foo),
    'base64 ENCoDE foo'       => test_zci(@foo),
    'base64 foo'              => test_zci(@foo),
    "base64 encode this text" => test_zci(
        'Base64 encoded: dGhpcyB0ZXh0',
        structured_answer => {
            input     => ['this text'],
            operation => 'Base64 encode',
            result    => 'dGhpcyB0ZXh0'
        }
    ),
    "base64 decode dGhpcyB0ZXh0" => test_zci(@this_text),
    "base64 dECoDE dGhpcyB0ZXh0" => test_zci(@this_text),
);

done_testing;
