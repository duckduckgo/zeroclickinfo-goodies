#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => 'mailto';

ddg_goodie_test(
        [qw(
                DDG::Goodie::Mailto
        )],
        'mail kappa@yandex.com' => test_zci(
            'kappa@yandex.com',
            html => qr/<a href="mailto:kappa\@yandex\.com">kappa\@yandex\.com<\/a>/,
        ),
        'mail press@duckduckgo.com' => test_zci(
            'press@duckduckgo.com',
            html => qr/<a href="mailto:press\@duckduckgo\.com">press\@duckduckgo\.com<\/a>/,
        ),
        'mail box' => undef,
        'mail tracking' => undef,
);

done_testing;
