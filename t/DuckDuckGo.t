#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'duckduckgo';
zci is_cached   => 1;

# The results should be static, so these facilitate easier testing of triggers.
my @about_result =
  ("DuckDuckGo's about page: https://duckduckgo.com/about", html => "DuckDuckGo's <a href='https://duckduckgo.com/about'>about page</a>.");
my @blog_result = ("DuckDuckGo's official blog: https://duck.co/blog", html => "DuckDuckGo's <a href='https://duck.co/blog'>official blog</a>."),
  my @help_result =
  ("Need help? Visit our help page: http://dukgo.com/help/", html => "Need help? Visit our <a href='http://dukgo.com/help/'>help page</a>.");
my @irc_result = (
    "DuckDuckGo's official IRC channel is #duckduckgo on irc.freenode.net.",
    html =>
      "DuckDuckGo's official IRC channel is <a href='http://webchat.freenode.net/?channels=duckduckgo'>#duckduckgo</a> on <a href='http://freenode.net/'>irc.freenode.net</a>"
);
my @merch_result = (
    "Thanks for the support! Check out the DuckDuckGo store for t-shirts, stickers, and other items: https://duck.co/help/community/swag",
    html =>
      "Thanks for the support! Check out the <a href='https://duck.co/help/community/swag'>DuckDuckGo store</a> for t-shirts, stickers, and other items."
);
my @shorturl_result = ("DuckDuckGo's short URL: http://ddg.gg/", html => "DuckDuckGo's short URL: <a href='http://ddg.gg/'>http://ddg.gg/</a>.");
my @zci_result = (
    "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results.",
    html => "Zero Click Info is the term DuckDuckGo uses for these boxes, which often provide useful instant answers above traditional results."
);

ddg_goodie_test([qw(
          DDG::Goodie::DuckDuckGo
          )
    ],
    'duckduckgo Zero-Click Info'            => test_zci(@zci_result),
    'ddg zeroclick'                         => test_zci(@zci_result),
    'duckduckgo help'                       => test_zci(@help_result),
    'duckduckgo about'                      => test_zci(@about_result),
    'ddg merch'                             => test_zci(@merch_result),
    'duckduckgo irc'                        => test_zci(@irc_result),
    'short URL for duck duck go'            => test_zci(@shorturl_result),
    "duckduckgo's about"                    => test_zci(@about_result),
    'duck duck go merchandise'              => test_zci(@merch_result),
    "ddgs irc"                              => test_zci(@irc_result),
    "the duckduckgo blog"                   => test_zci(@blog_result),
    'the short url of duck duck go'         => test_zci(@shorturl_result),
    "about duckduck go"                     => test_zci(@about_result),
    "duck duckgos help"                     => test_zci(@help_result),
    "where is the ddg irc"                  => test_zci(@irc_result),
    'what is the short url for duckduckgo?' => test_zci(@shorturl_result),
    irc                                     => undef,
);

done_testing;

