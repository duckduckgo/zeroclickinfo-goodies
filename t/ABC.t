#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'choice';
zci is_cached   => 0;

sub create_structured_answer
{
    my $data = shift;
    return {
        data => $data, #ignore(),
        templates => {
            group => 'text',
            moreAt => 0
        }
    };
}

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
        re(qr/(pick|axe) \(Random\)/),
        structured_answer => create_structured_answer(ignore())
    ),
    'choose yes or no' => test_zci(
        re(qr/(yes|no) \(Random\)/),
        structured_answer => create_structured_answer(ignore())
    ),
    'choose this or that or none' => test_zci(
        re(qr/(this|that|none) \(Random\)/),
        structured_answer => create_structured_answer(ignore())
    ),
    'pick this or that or none' => test_zci(
        re(qr/(this|that|none) \(Random\)/),
        structured_answer => create_structured_answer(ignore())
    ),
    'select heads or tails' => test_zci(
        re(qr/(heads|tails) \(Random\)/),
        structured_answer => create_structured_answer(ignore())
    ),
    'choose heads or tails' => test_zci(
        re(qr/(heads|tails) \(Random\)/),
        structured_answer => create_structured_answer(ignore())
    ),
    'choose duckduckgo or google or bing or something' => test_zci(
        'duckduckgo (Non-random)',
        structured_answer => create_structured_answer({
            title => "duckduckgo",
            subtitle => "Non-random selection from: duckduckgo, google, bing or something"
        })
    ),
    'choose Google OR DuckDuckGo OR Bing OR SOMETHING' => test_zci(
        'DuckDuckGo (Non-random)',
        structured_answer => create_structured_answer({
            title => "DuckDuckGo",
            subtitle => "Non-random selection from: Google, DuckDuckGo, Bing or SOMETHING"
        })
    ),
);

done_testing;
