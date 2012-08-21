#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'dessert';
zci is_cached => 0;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Desserts
        )],
        'desserts beginning with a'   => test_zci(/A dessert beginning with A is (.*)/),
        #"base64 encode this text" => test_zci("Base64 encoded: dGhpcyB0ZXh0"),
        #"base64 decode dGhpcyB0ZXh0" => test_zci("Base64 decoded: this text"),
);

done_testing;
