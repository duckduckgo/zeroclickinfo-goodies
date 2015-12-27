#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'choice';
zci is_cached   => 0;

sub create_structured_answer
{
    my ($query, $subtitle, $answer) = @_;
    return {
        id => 'abc',
        name => 'Answer',
        data => {
            title => $answer,
            subtitle => "$subtitle: $query"
        },
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
        qr/(pick|axe) \(Random\)/,
        structured_answer => create_structured_answer('pick or axe', 'Random selection from', qr/^(?:pick|axe)$/)
    ),
    'choose yes or no' => test_zci(
        qr/(yes|no) \(Random\)/,
        structured_answer => create_structured_answer('yes or no', 'Random selection from', qr/^(?:yes|no)$/)
    ),
    'choose this or that or none' => test_zci(
        qr/(this|that|none) \(Random\)/,
        structured_answer => create_structured_answer('this, that or none','Random selection from', qr/^(?:this|that|none)$/)
    ),
    'pick this or that or none' => test_zci(
        qr/(this|that|none) \(Random\)/,
        structured_answer => create_structured_answer('this, that or none', 'Random selection from', qr/^(?:this|that|none)$/)
    ),
    'select heads or tails' => test_zci(
        qr/(heads|tails) \(Random\)/,
        structured_answer => create_structured_answer('heads or tails', 'Random selection from', qr/^(?:heads|tails)$/)
    ),
    'choose heads or tails' => test_zci(
        qr/(heads|tails) \(Random\)/,
        structured_answer => create_structured_answer('heads or tails', 'Random selection from', qr/^(?:heads|tails)$/)
    ),
    'choose duckduckgo or google or bing or something' => test_zci(
        'duckduckgo (Non-random)',
        structured_answer => create_structured_answer('duckduckgo, google, bing or something', 'Non-random selection from', 'duckduckgo')
    ),
    'choose Google OR DuckDuckGo OR Bing OR SOMETHING' => test_zci(
        'DuckDuckGo (Non-random)',
        structured_answer => create_structured_answer('Google, DuckDuckGo, Bing or SOMETHING', 'Non-random selection from', 'DuckDuckGo')
    ),
);

done_testing;

