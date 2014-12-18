#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'choice';
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::ABC )],
    'choose'                                      => undef,
    'i choose'                                    => undef,
    'choose or'                                   => undef,
    'choose my house or your house'               => undef,
    'choose his or her house'                     => undef,
    'choose his or or her house'                  => undef,
    'choose from products like turkey or venison' => undef,
    'choose pick or axe'                          => test_zci(
        qr/(pick|axe) \(random\)/,
        structured_answer => {
            input     => ['pick or axe'],
            operation => 'random selection from',
            result    => qr/^(?:pick|axe)$/,
        }
    ),
    'choose yes or no' => test_zci(
        qr/(yes|no) \(random\)/,
        structured_answer => {
            input     => ['yes or no'],
            operation => 'random selection from',
            result    => qr/^(?:yes|no)$/,
        }
    ),
    'choose this or that or none' => test_zci(
        qr/(this|that|none) \(random\)/,
        structured_answer => {
            input     => ['this, that or none'],
            operation => 'random selection from',
            result    => qr/^(?:this|that|none)$/,
        }
    ),
    'pick this or that or none' => test_zci(
        qr/(this|that|none) \(random\)/,
        structured_answer => {
            input     => ['this, that or none'],
            operation => 'random selection from',
            result    => qr/^(?:this|that|none)$/,
        }
    ),
    'select heads or tails' => test_zci(
        qr/(heads|tails) \(random\)/,
        structured_answer => {
            input     => ['heads or tails'],
            operation => 'random selection from',
            result    => qr/^(?:heads|tails)$/,
        }
    ),
    'choose heads or tails' => test_zci(
        qr/(heads|tails) \(random\)/,
        structured_answer => {
            input     => ['heads or tails'],
            operation => 'random selection from',
            result    => qr/^(?:heads|tails)$/,
        }
    ),
    'choose duckduckgo or google or bing or something' => test_zci(
        'duckduckgo (non-random)',
        structured_answer => {
            input     => ['duckduckgo, google, bing or something'],
            operation => 'non-random selection from',
            result    => 'duckduckgo',
        }
    ),
    'choose Google OR DuckDuckGo OR Bing OR SOMETHING' => test_zci(
        'DuckDuckGo (non-random)',
        structured_answer => {
            input     => ['Google, DuckDuckGo, Bing or SOMETHING'],
            operation => 'non-random selection from',
            result    => 'DuckDuckGo',
        }
    ),
);

done_testing;

