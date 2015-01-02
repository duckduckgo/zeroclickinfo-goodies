#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sha';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Sha)],
    'shasum the duckdukcgo serach engine' => test_zci(
        '8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4',
        structured_answer => {
            input     => ['the duckdukcgo serach engine'],
            operation => 'SHA-1 hex hash',
            result    => '8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4'
        }
    ),
    'sha1sum the duckdukcgo serach engine' => test_zci(
        '8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4',
        structured_answer => {
            input     => ['the duckdukcgo serach engine'],
            operation => 'SHA-1 hex hash',
            result    => '8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4'
        }
    ),
    'sha-1 the duckdukcgo serach engine' => test_zci(
        '8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4',
        structured_answer => {
            input     => ['the duckdukcgo serach engine'],
            operation => 'SHA-1 hex hash',
            result    => '8af70bf86260fec05d7cc89e0f0be2aa3db5e5e4'
        }
    ),
    'sha256sum base64 the duckdukcgo serach engine' => test_zci(
        'XUKkFU44G21/OPBB47hIwC3Q1lb1Cl8ktI2GjyCDFrM=',
        structured_answer => {
            input     => ['the duckdukcgo serach engine'],
            operation => 'SHA-256 base64 hash',
            result    => 'XUKkFU44G21/OPBB47hIwC3Q1lb1Cl8ktI2GjyCDFrM='
        }
    ),
    'sha256sum base64 the duckdukcgo serach engine' => test_zci(
        'XUKkFU44G21/OPBB47hIwC3Q1lb1Cl8ktI2GjyCDFrM=',
        structured_answer => {
            input     => ['the duckdukcgo serach engine'],
            operation => 'SHA-256 base64 hash',
            result    => 'XUKkFU44G21/OPBB47hIwC3Q1lb1Cl8ktI2GjyCDFrM='
        }
    ),
    'sha-256 base64 the duckdukcgo serach engine' => test_zci(
        'XUKkFU44G21/OPBB47hIwC3Q1lb1Cl8ktI2GjyCDFrM=',
        structured_answer => {
            input     => ['the duckdukcgo serach engine'],
            operation => 'SHA-256 base64 hash',
            result    => 'XUKkFU44G21/OPBB47hIwC3Q1lb1Cl8ktI2GjyCDFrM='
        }
    ),
    'sha-1 base64 lorem ipsum' => test_zci(
        'v7d1mmfa62VBBJC02Yu52n0eos4=',
        structured_answer => {
            input     => ['lorem ipsum'],
            operation => 'SHA-1 base64 hash',
            result    => 'v7d1mmfa62VBBJC02Yu52n0eos4='
        }
    ),
    'sha-224 base64 lorem ipsum' => test_zci(
        '4ZHt8GAFcSWDUYztkswqwvrI1uRiOwIaUHNqkQ==',
        structured_answer => {
            input     => ['lorem ipsum'],
            operation => 'SHA-224 base64 hash',
            result    => '4ZHt8GAFcSWDUYztkswqwvrI1uRiOwIaUHNqkQ=='
        }
    ),
    'sha-256 base64 lorem ipsum' => test_zci(
        'Xiv1fT9AxLbfadrxk2y3ZvgyN0tPwCWafL/wbi9w8mk=',
        structured_answer => {
            input     => ['lorem ipsum'],
            operation => 'SHA-256 base64 hash',
            result    => 'Xiv1fT9AxLbfadrxk2y3ZvgyN0tPwCWafL/wbi9w8mk='
        }
    ),
    'sha-384 base64 lorem ipsum' => test_zci(
        'WXSTps8SiXV1JOVN/W9oszLHIUpxajNYkR71wJkHrcimVKGMHXIeGDsAJfmW9uJG',
        structured_answer => {
            input     => ['lorem ipsum'],
            operation => 'SHA-384 base64 hash',
            result    => 'WXSTps8SiXV1JOVN/W9oszLHIUpxajNYkR71wJkHrcimVKGMHXIeGDsAJfmW9uJG'
        }
    ),
    'sha-512 base64 lorem ipsum' => test_zci(
        '+A7r2aq7GhX7hp7VaNhYpcDco9XaB6QQ4b2Yh2ORjZc+NEgUYl98hEaVst42/9J68pDQ40NixR3uWUfVjUBSeg==',
        structured_answer => {
            input     => ['lorem ipsum'],
            operation => 'SHA-512 base64 hash',
            result    => '+A7r2aq7GhX7hp7VaNhYpcDco9XaB6QQ4b2Yh2ORjZc+NEgUYl98hEaVst42/9J68pDQ40NixR3uWUfVjUBSeg=='
        }
    ),
    'shasum hex this' => test_zci(
        'c2543fff3bfa6f144c2f06a7de6cd10c0b650cae',
        structured_answer => {
            input     => ['this'],
            operation => 'SHA-1 hex hash',
            result    => 'c2543fff3bfa6f144c2f06a7de6cd10c0b650cae'
        }
    ),
    'sha224sum base64 this' => test_zci(
        'kFct0af7OnZ8E66tO0CmyDv1uXW7nSRHon3JYg==',
        structured_answer => {
            input     => ['this'],
            operation => 'SHA-224 base64 hash',
            result    => 'kFct0af7OnZ8E66tO0CmyDv1uXW7nSRHon3JYg=='
        }
    ),

    'sha1sum "this"' => test_zci(
        'c2543fff3bfa6f144c2f06a7de6cd10c0b650cae',
        structured_answer => {
            input     => ['this'],
            operation => 'SHA-1 hex hash',
            result    => 'c2543fff3bfa6f144c2f06a7de6cd10c0b650cae'
        }
    ),
    'sha "this' => test_zci(
        'e1ea2c30284aa81804b52c034c997b06c5d7d4d9',
        structured_answer => {
            input     => ['&quot;this'],
            operation => 'SHA-1 hex hash',
            result    => 'e1ea2c30284aa81804b52c034c997b06c5d7d4d9'
        }
    ),
    'sha this"' => test_zci(
        '2d9d48e524574ae527fbd5e55ea2e7dcba84d4f9',
        structured_answer => {
            input     => ['this&quot;'],
            operation => 'SHA-1 hex hash',
            result    => '2d9d48e524574ae527fbd5e55ea2e7dcba84d4f9'
        }
    ),
    'sha "this and "that""' => test_zci(
        'aa6b22799b19374a5d01f07167fd0f3bea897bd0',
        structured_answer => {
            input     => ['this and &quot;that&quot;'],
            operation => 'SHA-1 hex hash',
            result    => 'aa6b22799b19374a5d01f07167fd0f3bea897bd0'
        }
    ),

    'sha hash of "this and that"' => test_zci(
        '4f813651453b11db74cbc36ccddea13f109e8412',
        structured_answer => {
            input     => ['this and that'],
            operation => 'SHA-1 hex hash',
            result    => '4f813651453b11db74cbc36ccddea13f109e8412'
        }
    ),
    'sha hash of this and that' => test_zci(
        '4f813651453b11db74cbc36ccddea13f109e8412',
        structured_answer => {
            input     => ['this and that'],
            operation => 'SHA-1 hex hash',
            result    => '4f813651453b11db74cbc36ccddea13f109e8412'
        }
    ),
    'sha hash this and that' => test_zci(
        '4f813651453b11db74cbc36ccddea13f109e8412',
        structured_answer => {
            input     => ['this and that'],
            operation => 'SHA-1 hex hash',
            result    => '4f813651453b11db74cbc36ccddea13f109e8412'
        }
    ),
    'sha256 base64 hash of "this and that"' => test_zci(
        '6GPBrEJhmitCmgh3WmrNif9MLGuNrhLjRhpfpjsvkvU=',
        structured_answer => {
            input     => ['this and that'],
            operation => 'SHA-256 base64 hash',
            result    => '6GPBrEJhmitCmgh3WmrNif9MLGuNrhLjRhpfpjsvkvU='
        }
    ),

    'shasum <script>alert( "hello" )<script>' => test_zci(
        '10c4a3b691419901a56fade7e4b5e04fe4ef6570',
        structured_answer => {
            input     => ['&lt;script&gt;alert( &quot;hello&quot; )&lt;script&gt;'],
            operation => 'SHA-1 hex hash',
            result    => '10c4a3b691419901a56fade7e4b5e04fe4ef6570'
        }
    ),
    'shasum script>ALERT hello script>' => test_zci(
        '9ef5127abf5a46ef82a1bc10e6a8447a205644cd',
        structured_answer => {
            input     => ['script&gt;ALERT hello script&gt;'],
            operation => 'SHA-1 hex hash',
            result    => '9ef5127abf5a46ef82a1bc10e6a8447a205644cd'
        }
    ),
    'sha1 & / " \\\' ; < > ' => test_zci(
        '58ae7fba7b9df6da46cb42e6e3ad2ddc3f6a2a58',
        structured_answer => {
            input     => ['&amp; / &quot; \&#39; ; &lt; &gt;'],
            operation => 'SHA-1 hex hash',
            result    => '58ae7fba7b9df6da46cb42e6e3ad2ddc3f6a2a58'
        }
    ),
    'sha password' => test_zci(
        '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',
        structured_answer => {
            input     => ['password'],
            operation => 'SHA-1 hex hash',
            result    => '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8'
        }
    ),
    'shadow' => undef
);

done_testing;
