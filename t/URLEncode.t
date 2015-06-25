#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'encoded_url';
zci is_cached   => 1;

ddg_goodie_test(
    [qw(DDG::Goodie::URLEncode)],

    # Primary example queries
    'url encode https://duckduckgo.com/' => test_zci(
        "Percent-encoded URL: https%3A%2F%2Fduckduckgo.com%2F",
        structured_answer => {
            input     => ['https://duckduckgo.com/'],
            operation => 'URL percent-encode',
            result    => 'https%3A%2F%2Fduckduckgo.com%2F'
        }
    ),

    'encode url xkcd.com/blag' => test_zci(
        "Percent-encoded URL: xkcd.com%2Fblag",
        structured_answer => {
            input     => ['xkcd.com/blag'],
            operation => 'URL percent-encode',
            result    => 'xkcd.com%2Fblag'
        }
    ),

    # Secondary example queries
    'http://arstechnica.com/ url escape' => test_zci(
        "Percent-encoded URL: http%3A%2F%2Farstechnica.com%2F",
        structured_answer => {
            input     => ['http://arstechnica.com/'],
            operation => 'URL percent-encode',
            result    => 'http%3A%2F%2Farstechnica.com%2F'
        }
    ),

    'apple.com/mac/ escape url' => test_zci(
        "Percent-encoded URL: apple.com%2Fmac%2F",
        structured_answer => {
            input     => ['apple.com/mac/'],
            operation => 'URL percent-encode',
            result    => 'apple.com%2Fmac%2F',
        }
    ),

    'urlencode www.xkcd.com/a-webcomic-of-romance+math+sarcasm+language' => test_zci(
        "Percent-encoded URL: www.xkcd.com%2Fa-webcomic-of-romance%2Bmath%2Bsarcasm%2Blanguage",
        structured_answer => {
            input     => ['www.xkcd.com/a-webcomic-of-romance+math+sarcasm+language'],
            operation => 'URL percent-encode',
            result    => 'www.xkcd.com%2Fa-webcomic-of-romance%2Bmath%2Bsarcasm%2Blanguage'
        }
    ),

    'https://example.com/zero#clickinfo^<goodies>;spice:fathead-\ encodeurl' => test_zci(
        "Percent-encoded URL: https%3A%2F%2Fexample.com%2Fzero%23clickinfo%5E%3Cgoodies%3E%3Bspice%3Afathead-%5C",
        structured_answer => {
            input     => ['https://example.com/zero#clickinfo^&lt;goodies&gt;;spice:fathead-\\'],
            operation => 'URL percent-encode',
            result    => 'https%3A%2F%2Fexample.com%2Fzero%23clickinfo%5E%3Cgoodies%3E%3Bspice%3Afathead-%5C'
        }
    ),

    'urlescape https://example.org/the answer to "[life], (the universe) .and. <everything>"' => test_zci(
        "Percent-encoded URL: https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22",
        structured_answer => {
            input     => ['https://example.org/the answer to &quot;[life], (the universe) .and. &lt;everything&gt;&quot;'],
            operation => 'URL percent-encode',
            result    => 'https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22'
        }
    ),

    'www.heroku.com/{rawwr!@#$%^&*()+=__} escapeurl' => test_zci(
        "Percent-encoded URL: www.heroku.com%2F%7Brawwr!%40%23%24%25%5E%26*()%2B%3D__%7D",
        structured_answer => {
            input     => ['www.heroku.com/{rawwr!@#$%^&amp;*()+=__}'],
            operation => 'URL percent-encode',
            result    => 'www.heroku.com%2F%7Brawwr!%40%23%24%25%5E%26*()%2B%3D__%7D',
        }
    ),

    'hello there escapeurl' => test_zci(
        "Percent-encoded URL: hello%20there",
        structured_answer => {
            input     => ['hello there'],
            operation => 'URL percent-encode',
            result    => 'hello%20there'
        }
    ),
);

done_testing;
