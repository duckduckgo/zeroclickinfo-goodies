#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'base64_conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Base64
        )],
        'base64 encode foo'   => test_zci('Base64 encoded: Zm9v'),
        "base64 encode this text" => test_zci("Base64 encoded: dGhpcyB0ZXh0"),
        "base64 decode dGhpcyB0ZXh0" => test_zci("Base64 decoded: this text"),
);

done_testing;
