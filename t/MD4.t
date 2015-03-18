#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "md4";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::MD4 )],
    'md4 this string' => test_zci(
        '053067f13569dab01dbb0fcbfef3dffa',
        structured_answer => {
            input     => ['this string'],
            operation => 'MD4 hex hash',
            result    => '053067f13569dab01dbb0fcbfef3dffa'
        }
    ),
    'MD4 this string' => test_zci(
        '053067f13569dab01dbb0fcbfef3dffa',
        structured_answer => {
            input     => ['this string'],
            operation => 'MD4 hex hash',
            result    => '053067f13569dab01dbb0fcbfef3dffa'
        }
    ),
    'md4sum this string' => test_zci(
        '053067f13569dab01dbb0fcbfef3dffa',
        structured_answer => {
            input     => ['this string'],
            operation => 'MD4 hex hash',
            result    => '053067f13569dab01dbb0fcbfef3dffa'
        }
    ),
    'md4sum base64 this string' => test_zci(
        'BTBn8TVp2rAduw/L/vPf+g==',
        structured_answer => {
            input     => ['this string'],
            operation => 'MD4 base64 hash',
            result    => 'BTBn8TVp2rAduw/L/vPf+g=='
        }
    ),
    'md4 hash this string' => test_zci(
        '053067f13569dab01dbb0fcbfef3dffa',
        structured_answer => {
            input     => ['this string'],
            operation => 'MD4 hex hash',
            result    => '053067f13569dab01dbb0fcbfef3dffa'
        }
    ),
    'md4 hash of this string' => test_zci(
        '053067f13569dab01dbb0fcbfef3dffa',
        structured_answer => {
            input     => ['this string'],
            operation => 'MD4 hex hash',
            result    => '053067f13569dab01dbb0fcbfef3dffa'
        }
    ),
    'md4 base64 this string' => test_zci(
        'BTBn8TVp2rAduw/L/vPf+g==',
        structured_answer => {
            input     => ['this string'],
            operation => 'MD4 base64 hash',
            result    => 'BTBn8TVp2rAduw/L/vPf+g=='
        }
    ),
    'md4 <script>alert("ddg")</script>' => test_zci(
        '5b9b4baf02269790c6f1c6ad0fecf55b',
        structured_answer => {
            input     => ['&lt;script&gt;alert(&quot;ddg&quot;)&lt;/script&gt;'],
            operation => 'MD4 hex hash',
            result    => '5b9b4baf02269790c6f1c6ad0fecf55b'
        }
    ),
    'md4 & / " \\\' ; < >' => test_zci(
        '34a291b941a1754761cbf345d518b985',
        structured_answer => {
            input     => ['&amp; / &quot; \&#39; ; &lt; &gt;'],
            operation => 'MD4 hex hash',
            result    => '34a291b941a1754761cbf345d518b985'
        }
    ),
    'md5 this string' => undef,
);

done_testing;
