#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

use utf8;

zci answer_type => 'leet_speak';
zci is_cached   => 1;

sub build_test
{
    my ($text, $title, $input) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $title,
            subtitle => "Leet speak: $input",
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    ['DDG::Goodie::LeetSpeak'],
    'leetspeak hello world !' => build_test('Leet Speak: |-|3|_|_0 \^/0|2|_|) !', '|-|3|_|_0 \^/0|2|_|) !', 'hello world !'),
    'l33tsp34k hElLo WORlD !' => build_test('Leet Speak: |-|3|_|_0 \^/0|2|_|) !', '|-|3|_|_0 \^/0|2|_|) !', 'hElLo WORlD !'),
    'what is l33t' => build_test(q~Leet Speak: \^/|-|/-\'][' 15~, q~\^/|-|/-\'][' 15~, 'what is'),
    'leet speak leetspeak' => build_test(q~Leet Speak: |_33']['5|D3/-\|<~, q~|_33']['5|D3/-\|<~, 'leetspeak'),
    'l33t sp34k /!§ ;€' => build_test(q~Leet Speak: /!§ ;€~, q~/!§ ;€~, '/!§ ;€'),
    'l33tsp34k' => undef,
);

done_testing;
