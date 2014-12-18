#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

use utf8;

zci answer_type => 'leet_speak';
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::LeetSpeak'],
    'leetspeak hello world !' => test_zci(
        'Leet Speak: |-|3|_|_0 \^/0|2|_|) !',
        structured_answer => {
            input     => ['hello world !'],
            operation => 'leet speak',
            result    => '|-|3|_|_0 \^/0|2|_|) !'
        }
    ),
    'l33tsp34k hElLo WORlD !' => test_zci(
        'Leet Speak: |-|3|_|_0 \^/0|2|_|) !',
        structured_answer => {
            input     => ['hElLo WORlD !'],
            operation => 'leet speak',
            result    => '|-|3|_|_0 \^/0|2|_|) !'
        }
    ),
    'what is l33t' => test_zci(
        q~Leet Speak: \^/|-|/-\'][' 15~,
        structured_answer => {
            input     => ['what is'],
            operation => 'leet speak',
            result    => q~\^/|-|/-\'][' 15~,
        }
    ),
    'leet speak leetspeak' => test_zci(
        q~Leet Speak: |_33']['5|D3/-\|<~,
        structured_answer => {
            input     => ['leetspeak'],
            operation => 'leet speak',
            result    => q~|_33']['5|D3/-\|<~,
        }
    ),
    'l33t sp34k /!§ ;€' => test_zci(
        q~Leet Speak: /!§ ;€~,
        structured_answer => {
            input     => ['/!§ ;€'],
            operation => 'leet speak',
            result    => q~/!§ ;€~,
        }
    ),
    'l33tsp34k' => undef,
);

done_testing;
