#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'flip_text';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::FlipText)],
    'flip text test' => test_zci(
        "\x{0287}\x{0073}\x{01DD}\x{0287}",
        structured_answer => {
            input     => ['test'],
            operation => 'Flip text',
            result    => '&#x287;s&#x1DD;&#x287;'
        }
    ),
    'mirror text test' => test_zci(
        "\x{0287}\x{0073}\x{01DD}\x{0287}",
        structured_answer => {
            input     => ['test'],
            operation => 'Flip text',
            result    => '&#x287;s&#x1DD;&#x287;'
        }
    ),
    'flip text my sentence' => test_zci(
        'ǝɔuǝʇuǝs ʎɯ',
        structured_answer => {
            input     => ['my sentence'],
            operation => 'Flip text',
            result    => '&#x1DD;&#x254;u&#x1DD;&#x287;u&#x1DD;s &#x28E;&#x26F;'
        }
    ),
    'mirror text text' => test_zci(
        'ʇxǝʇ',
        structured_answer => {
            input     => ['text'],
            operation => 'Flip text',
            result    => '&#x287;x&#x1DD;&#x287;'
        }
    ),
);

done_testing;
