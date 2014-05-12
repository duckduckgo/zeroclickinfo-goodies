#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'duckduckgo';
zci is_cached   => 1;

ddg_goodie_test([qw(
          DDG::Goodie::DuckDuckGo
          )
    ],
    'duckduckgo Zero-Click Info' => test_zci(
        "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results.",
        html => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results."
    ),
    'ddg zeroclick' => test_zci(
        "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results.",
        html => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results."
    ),
    'duckduckgo help' => test_zci(
        "Need help? Visit our help page: http://dukgo.com/help/",
        html => "Need help? Visit our <a href='http://dukgo.com/help/'>help page</a>."
    ),
    'duckduckgo about' => test_zci(
        "DuckDuckGo's about page: https://duckduckgo.com/about", html => "DuckDuckGo's <a href='https://duckduckgo.com/about'>about page</a>."
    ),
    'ddg merch' => test_zci(
        "Thanks for the support! Check out the DuckDuckGo store for t-shirts, stickers, and other items: https://duck.co/help/community/swag",
        html =>
          "Thanks for the support! Check out the <a href='https://duck.co/help/community/swag'>DuckDuckGo store</a> for t-shirts, stickers, and other items."
    ),
    'duckduckgo irc' => test_zci(
        "DuckDuckGo's official IRC channel is #duckduckgo on irc.freenode.net.",
        html =>
          "DuckDuckGo's official IRC channel is <a href='http://webchat.freenode.net/?channels=duckduckgo'>#duckduckgo</a> on <a href='http://freenode.net/'>irc.freenode.net</a>"
    ),
    irc => undef,
);

done_testing;

