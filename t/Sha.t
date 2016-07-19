#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'sha';
zci is_cached   => 1;

sub build_structured_answer {
    my ($sha, $sha_version, $sha_type) = @_;
    return $sha,
        structured_answer => {
            data => {
                title => $sha,
                subtitle => "$sha_version $sha_type hash",
            },
            templates => {
                group => 'text',
            }
        }
}

sub build_test {
    test_zci(build_structured_answer(@_));
}

ddg_goodie_test(
    [qw( DDG::Goodie::Sha)],
    'shasum the duckdukcgo serach engine'           => build_test('8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4', 'SHA-1', 'hex'),
    'sha1sum the duckdukcgo serach engine'          => build_test('8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4', 'SHA-1', 'hex'),
    'sha-1 the duckdukcgo serach engine'            => build_test('8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4', 'SHA-1', 'hex'),
    'sha256sum base64 the duckdukcgo serach engine' => build_test('XUKkFU44G21/OPBB47hIwC3Q1lb1Cl8ktI2GjyCDFrM=', 'SHA-256', 'base64'),
    'sha-256 base64 the duckdukcgo serach engine'   => build_test('XUKkFU44G21/OPBB47hIwC3Q1lb1Cl8ktI2GjyCDFrM=', 'SHA-256', 'base64'),
    'sha-1 base64 lorem ipsum'                      => build_test('v7d1mmfa62VBBJC02Yu52n0eos4=', 'SHA-1', 'base64'),
    'sha-224 base64 lorem ipsum'                    => build_test('4ZHt8GAFcSWDUYztkswqwvrI1uRiOwIaUHNqkQ==', 'SHA-224', 'base64'),
    'sha-256 base64 lorem ipsum'                    => build_test('Xiv1fT9AxLbfadrxk2y3ZvgyN0tPwCWafL/wbi9w8mk=', 'SHA-256', 'base64'),
    'sha-384 base64 lorem ipsum'                    => build_test('WXSTps8SiXV1JOVN/W9oszLHIUpxajNYkR71wJkHrcimVKGMHXIeGDsAJfmW9uJG', 'SHA-384', 'base64'),
    'sha-512 base64 lorem ipsum'                    => build_test('+A7r2aq7GhX7hp7VaNhYpcDco9XaB6QQ4b2Yh2ORjZc+NEgUYl98hEaVst42/9J68pDQ40NixR3uWUfVjUBSeg==', 'SHA-512', 'base64'),
    'shasum hex this'                               => build_test('c2543fff3bfa6f144c2f06a7de6cd10c0b650cae', 'SHA-1', 'hex'),
    'sha224sum base64 this'                         => build_test('kFct0af7OnZ8E66tO0CmyDv1uXW7nSRHon3JYg==', 'SHA-224', 'base64'),
    'sha1sum "this"'                                => build_test('c2543fff3bfa6f144c2f06a7de6cd10c0b650cae', 'SHA-1', 'hex'),
    'sha "this'                                     => build_test('e1ea2c30284aa81804b52c034c997b06c5d7d4d9', 'SHA-1', 'hex'),
    'sha this"'                                     => build_test('2d9d48e524574ae527fbd5e55ea2e7dcba84d4f9', 'SHA-1', 'hex'),
    'sha "this and "that""'                         => build_test('aa6b22799b19374a5d01f07167fd0f3bea897bd0', 'SHA-1', 'hex'),
    'sha hash of "this and that"'                   => build_test('4f813651453b11db74cbc36ccddea13f109e8412', 'SHA-1', 'hex'),
    'sha hash of this and that'                     => build_test('4f813651453b11db74cbc36ccddea13f109e8412', 'SHA-1', 'hex'),
    'sha hash this and that'                        => build_test('4f813651453b11db74cbc36ccddea13f109e8412', 'SHA-1', 'hex'),
    'sha256 base64 hash of "this and that"'         => build_test('6GPBrEJhmitCmgh3WmrNif9MLGuNrhLjRhpfpjsvkvU=', 'SHA-256', 'base64'),
    'shasum <script>alert( "hello" )<script>'       => build_test('10c4a3b691419901a56fade7e4b5e04fe4ef6570', 'SHA-1', 'hex'),
    'shasum script>ALERT hello script>'             => build_test('9ef5127abf5a46ef82a1bc10e6a8447a205644cd', 'SHA-1', 'hex'),
    'sha1 & / " \\\' ; < > '                        => build_test('58ae7fba7b9df6da46cb42e6e3ad2ddc3f6a2a58', 'SHA-1', 'hex'),
    'sha password'                                  => build_test('5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', 'SHA-1', 'hex'),
    'shadow'                                        => undef,
);

done_testing;
