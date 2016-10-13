#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "rc4";
zci is_cached   => 1;

sub build_test {
    my ($direction, $input, $key, $answer) = @_;
    return test_zci("RC4 $direction: $input, with key: $key is $answer", structured_answer => {
        data => {
            title => $answer,
            subtitle => "RC4 $direction: $input, Key: $key"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw(
        DDG::Goodie::Rc4
    )],
    'rc4 en mysecretkey hello' => build_test("Encrypt", "hello", "mysecretkey", "grYU1K8="),
    'rc4 de duck yWrJniG/nNg=' => build_test("Decrypt", "yWrJniG/nNg=", "duck", "DdgRocks"),
    'rc4 ' => undef,
    'rc4 enc missing' => undef,
    'rc4 no operation' => undef
);

done_testing;
