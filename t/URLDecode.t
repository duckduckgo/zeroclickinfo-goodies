#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'decoded_url';
zci is_cached   => 1;

ddg_goodie_test(
    [qw(DDG::Goodie::URLDecode)],

    # Primary example queries
    'url decode https%3A%2F%2Fduckduckgo.com%2F' => test_zci(
        "URL Decoded: https://duckduckgo.com/",
        structured_answer => {
            input     => ['https%3A%2F%2Fduckduckgo.com%2F'],
            operation => 'URL decode',
            result    => 'https://duckduckgo.com/'
        }
    ),
    'decode url xkcd.com%2Fblag' => test_zci(
        "URL Decoded: xkcd.com/blag",
        structured_answer => {
            input     => ['xkcd.com%2Fblag'],
            operation => 'URL decode',
            result    => 'xkcd.com/blag'
        }
    ),
    # Secondary example queries
    'http%3A%2F%2Farstechnica.com%2F url unescape' => test_zci(
        "URL Decoded: http://arstechnica.com/",
        structured_answer => {
            input     => ['http%3A%2F%2Farstechnica.com%2F'],
            operation => 'URL decode',
            result    => 'http://arstechnica.com/'
        }
    ),
    'linux.com%2Ftour%2F unescape url' => test_zci(
        "URL Decoded: linux.com/tour/",
        structured_answer => {
            input     => ['linux.com%2Ftour%2F'],
            operation => 'URL decode',
            result    => 'linux.com/tour/'
        }
    ),
    'urldecode www.xkcd.com%2Fa-webcomic-of-romance%2Bmath%2Bsarcasm%2Blanguage' => test_zci(
        "URL Decoded: www.xkcd.com/a-webcomic-of-romance+math+sarcasm+language",
        structured_answer => {
            input     => ['www.xkcd.com%2Fa-webcomic-of-romance%2Bmath%2Bsarcasm%2Blanguage'],
            operation => 'URL decode',
            result    => 'www.xkcd.com/a-webcomic-of-romance+math+sarcasm+language'
        }
    ),
    'unescapeurl https%3A%2F%2Fexample.com%2Fzero%23clickinfo%5E%3Cgoodies%3E%3Bspice%3Afathead-%5C' => test_zci(
        'URL Decoded: https://example.com/zero#clickinfo^<goodies>;spice:fathead-\\',
        structured_answer => {
            input     => ['https%3A%2F%2Fexample.com%2Fzero%23clickinfo%5E%3Cgoodies%3E%3Bspice%3Afathead-%5C'],
            operation => 'URL decode',
            result    => 'https://example.com/zero#clickinfo^&lt;goodies&gt;;spice:fathead-\\'
        }
    ),
    'urlunescape https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22' => test_zci(
        qq`URL Decoded: https://example.org/the answer to "[life], (the universe) .and. <everything>"`,
        structured_answer => {
            input     => ['https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22'],
            operation => 'URL decode',
            result    => 'https://example.org/the answer to &quot;[life], (the universe) .and. &lt;everything&gt;&quot;'
        }
    ),
    'https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22' => test_zci(
        qq`URL Decoded: https://example.org/the answer to "[life], (the universe) .and. <everything>"`,
        structured_answer => {
            input     => ['https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22'],
            operation => 'URL decode',
            result    => 'https://example.org/the answer to &quot;[life], (the universe) .and. &lt;everything&gt;&quot;'
        }
    ),
    'www.heroku.com%2F%7Brawwr!%40%23%24%25%5E%26*()%2B%3D__%7D unescapeurl' => test_zci(
        'URL Decoded: www.heroku.com/{rawwr!@#$%^&*()+=__}',
        structured_answer => {
            input     => ['www.heroku.com%2F%7Brawwr!%40%23%24%25%5E%26*()%2B%3D__%7D'],
            operation => 'URL decode',
            result    => 'www.heroku.com/{rawwr!@#$%^&amp;*()+=__}'
        }
    ),
    'urldecode %3Cscript%3Ealert(1)%3C%2Fscript%3E' => test_zci(
        "URL Decoded: <script>alert(1)</script>",
        structured_answer => {
            input     => ['%3Cscript%3Ealert(1)%3C%2Fscript%3E'],
            operation => 'URL decode',
            result    => '&lt;script&gt;alert(1)&lt;/script&gt;'
        }
    ),
    'https%3A%2F%2Fduckduckgo.com%2F' => test_zci(
        "URL Decoded: https://duckduckgo.com/",
        structured_answer => {
            input     => ['https%3A%2F%2Fduckduckgo.com%2F'],
            operation => 'URL decode',
            result    => 'https://duckduckgo.com/'
        }
    ),
    '%20' => test_zci(
        'URL Decoded: Space',
        structured_answer => {
            input     => ['%20'],
            operation => 'URL decode',
            result    => 'Space'
        }
    ),
    'hello there unescapeurl' => undef,
    '38% of 100 GBP'          => undef,
    'url decode tool'         => undef,
    'url decode online'       => undef
);

done_testing;
