#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "md4";
zci is_cached   => 1;

sub build_test 
{
    my ($text, $type, $input) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => "$text",
            subtitle => "MD4 $type hash: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::MD4 )],
    'md4 this string' => build_test('053067f13569dab01dbb0fcbfef3dffa', "hex", "this string"),
    'MD4 this string' => build_test('053067f13569dab01dbb0fcbfef3dffa', "hex", "this string"),
    'md4sum this string' => build_test('053067f13569dab01dbb0fcbfef3dffa', "hex", "this string"),
    'md4sum base64 this string' => build_test('BTBn8TVp2rAduw/L/vPf+g==', "base64", "this string"),
    'md4 hash this string' => build_test('053067f13569dab01dbb0fcbfef3dffa', "hex", "this string"),
    'md4 hash of this string' => build_test('053067f13569dab01dbb0fcbfef3dffa',"hex", "this string"),
    'md4 base64 this string' => build_test('BTBn8TVp2rAduw/L/vPf+g==', "base64", "this string"),
    'md4 <script>alert("ddg")</script>' => build_test('5b9b4baf02269790c6f1c6ad0fecf55b', "hex", '<script>alert("ddg")</script>'),
    'md4 & / " \\\' ; < >' => build_test('34a291b941a1754761cbf345d518b985', "hex", '& / " \\\' ; < >'),
    'md5 this string' => undef,
);

done_testing;
