#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'duckduckgo';
zci is_cached   => 1;

# The results should be static, so these facilitate easier testing of triggers.
my @about_result = (
    "DuckDuckGo's about page: https://duckduckgo.com/about",
    structured_answer => {
        input     => [],
        operation => 'DuckDuckGo info',
        result    => "DuckDuckGo's <a href='https://duckduckgo.com/about'>about page</a>."
    });
my @blog_result = (
    "DuckDuckGo's official blog: https://duck.co/blog",
    structured_answer => {
        input     => [],
        operation => 'DuckDuckGo info',
        result    => "DuckDuckGo's <a href='https://duck.co/blog'>official blog</a>."
    });
my @help_result = (
    "Need help? Visit our help page: http://dukgo.com/help/",
    structured_answer => {
        input     => [],
        operation => 'DuckDuckGo info',
        result    => "Need help? Visit our <a href='http://dukgo.com/help/'>help page</a>."
    });
my @irc_result = (
    "DuckDuckGo's official IRC channel is #duckduckgo on irc.freenode.net.",
    structured_answer => {
        input     => [],
        operation => 'DuckDuckGo info',
        result =>
          "DuckDuckGo's official IRC channel is <a href='http://webchat.freenode.net/?channels=duckduckgo'>#duckduckgo</a> on <a href='http://freenode.net/'>irc.freenode.net</a>"
    });
my @merch_result = (
    "Thanks for the support! Check out the DuckDuckGo store for t-shirts, stickers, and other items: https://duck.co/help/community/swag",
    structured_answer => {
        input     => [],
        operation => 'DuckDuckGo info',
        result =>
          "Thanks for the support! Check out the <a href='https://duck.co/help/community/swag'>DuckDuckGo store</a> for t-shirts, stickers, and other items."
    });
my @tor_result = (
    "DuckDuckGo's service on Tor: http://3g2upl4pq6kufc4m.onion",
    structured_answer => {
        input     => [],
        operation => 'DuckDuckGo info',
        result    => "DuckDuckGo's <a href='http://3g2upl4pq6kufc4m.onion'>service on Tor</a>."
    });
my @shorturl_result = (
    "DuckDuckGo's short URL: http://ddg.gg/",
    structured_answer => {
        input     => [],
        operation => 'DuckDuckGo info',
        result    => "DuckDuckGo's short URL: <a href='http://ddg.gg/'>http://ddg.gg/</a>."
    });
my @zci_result = (
    "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results.",
    structured_answer => {
        input     => [],
        operation => 'DuckDuckGo info',
        result => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results."
    });

ddg_goodie_test(
    [qw( DDG::Goodie::DuckDuckGo )],
    # Primary example queries
    'duckduckgo help' => test_zci(@help_result),
    # Secondary example queries
    "ddg tor"                    => test_zci(@tor_result),
    'short URL for duck duck go' => test_zci(@shorturl_result),
    # Other queries
    'duckduckgo Zero-Click Info'            => test_zci(@zci_result),
    'ddg zeroclick'                         => test_zci(@zci_result),
    'duckduckgo about'                      => test_zci(@about_result),
    'ddg merch'                             => test_zci(@merch_result),
    'duckduckgo irc'                        => test_zci(@irc_result),
    "duckduckgo's about"                    => test_zci(@about_result),
    'duck duck go merchandise'              => test_zci(@merch_result),
    "ddgs irc"                              => test_zci(@irc_result),
    "the duckduckgo blog"                   => test_zci(@blog_result),
    'the short url of duck duck go'         => test_zci(@shorturl_result),
    "about duckduck go"                     => test_zci(@about_result),
    "duck duckgos help"                     => test_zci(@help_result),
    "where is the ddg irc"                  => test_zci(@irc_result),
    'what is the short url for duckduckgo?' => test_zci(@shorturl_result),
    "ddg on onion"                          => test_zci(@tor_result),
    "tor on duck duck go"                   => test_zci(@tor_result),
    "duckduckgo onion service"              => test_zci(@tor_result),
    "ddg in tor"                            => test_zci(@tor_result),
    'duckduckgo t-shirt'                    => test_zci(@merch_result),
    'ddg t shirts'                          => test_zci(@merch_result),
    'duck duck go tee'                      => test_zci(@merch_result),
    # Intentionally ignored queries
    irc => undef,
);

done_testing;

