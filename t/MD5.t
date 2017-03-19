#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'md5';
zci is_cached   => 1;


sub build_test
{
    my ($text, $type, $input) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $text,
            subtitle => "MD5 $type hash: $input"
        },
        templates => {
            group => 'text'
        }
    });
}


ddg_goodie_test(
    [qw( DDG::Goodie::MD5)],
    'md5 digest this!' => build_test('3838c8fb10a114e6d21203359ef147ad', "hex", "digest this!"),
    'duckduckgo md5' => build_test('96898bb8544fa56b03c08cdc09886c6c', "hex", "duckduckgo"),
    'md5sum the sum of a string' => build_test('a704c8833f9850cd342ead27207ca1a1', "hex", "the sum of a string"),
    'md5 of password' => build_test('5f4dcc3b5aa765d61d8327deb882cf99', "hex", "password"),
    'md5sum of "this"' => build_test('9e925e9341b490bfd3b4c4ca3b0c1ef2', "hex", "this"),
    'md5 of "this' => build_test('53d3e72f097a74f6d439fa88b91d5a71', "hex", '"this'),
    'md5 hash' => build_test('0800fc577294c34e0b28ad2839435945', "hex", "hash"),
    'md5 hash         ' => build_test('0800fc577294c34e0b28ad2839435945', "hex", "hash"),
    'md5 hash of' => build_test('8bf8854bebe108183caeb845c7676ae4', "hex", "of"),
    'md5 hash of  password ' => build_test('5f4dcc3b5aa765d61d8327deb882cf99', "hex", "password"),
    'md5 base64 hash of duckduckgo' => build_test('lomLuFRPpWsDwIzcCYhsbA==', "base64", "duckduckgo"),
    'md5 base64 duckduckgo' => build_test('lomLuFRPpWsDwIzcCYhsbA==', "base64", "duckduckgo"),
    'md5 base64 "duckduckgo"' => build_test('lomLuFRPpWsDwIzcCYhsbA==', "base64", "duckduckgo"),
    'md5 base64 hex' => build_test('uNG0Pq5zWHula671dHCeyw==', "base64", "hex"),
    'md5 hex duckduckgo' => build_test('96898bb8544fa56b03c08cdc09886c6c', "hex", "duckduckgo"),
    'md5 hex "duckduckgo"' => build_test('96898bb8544fa56b03c08cdc09886c6c', "hex", "duckduckgo"),
    'md5 hex base64' => build_test('95a1446a7120e4af5c0c8878abb7e6d2', "hex", "base64"),
    'md5 base64 this string' => build_test('xzix7ki/mKlygQ8V94J05Q==', "base64", "this string"),
    'md5sum <script>alert( "hello" )<script>' => build_test('57757f49c3ceb9d1b65c3b5ca0b5bd2d', "hex", '<script>alert( "hello" )<script>'),
    'md5sum script>ALERT hello script>' => build_test('a5e4903040077d90e9dd32da99d01b91', "hex", 'script>ALERT hello script>'),
    'md5sum & / " \' ; < > ' => build_test('48ff1acf53de360edc32cabd5b30e7b4',"hex", "& / \" \' ; < >"),
    # Queries that should be ignored
    'test.tar.gz md5' => undef,
    'md5 test.PDF'  => undef,
    'md5sum test.iso' => undef,
);

done_testing;
