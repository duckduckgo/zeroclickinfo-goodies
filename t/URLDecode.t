#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'decoded_url';

ddg_goodie_test(
    [qw(DDG::Goodie::URLDecode)],

    # Primary example queries
    'url decode https%3A%2F%2Fduckduckgo.com%2F' => test_zci(
        "URL Decoded: https://duckduckgo.com/",
        html => qr#https://duckduckgo\.com/#
    ),
    'decode url xkcd.com%2Fblag' => test_zci(
        "URL Decoded: xkcd.com/blag",
        html => qr#xkcd\.com/blag#
    ),
    # Secondary example queries
    'http%3A%2F%2Farstechnica.com%2F url unescape' => test_zci(
        "URL Decoded: http://arstechnica.com/",
        html => qr#http://arstechnica\.com/#
    ),
    'linux.com%2Ftour%2F unescape url' => test_zci(
        "URL Decoded: linux.com/tour/",
        html => qr#linux.com/tour/#
    ),
    'urldecode www.xkcd.com%2Fa-webcomic-of-romance%2Bmath%2Bsarcasm%2Blanguage' => test_zci(
        "URL Decoded: www.xkcd.com/a-webcomic-of-romance+math+sarcasm+language",
        html => qr#www\.xkcd\.com/a-webcomic-of-romance\+math\+sarcasm\+language#
    ),
    'unescapeurl https%3A%2F%2Fexample.com%2Fzero%23clickinfo%5E%3Cgoodies%3E%3Bspice%3Afathead-%5C' => test_zci(
        'URL Decoded: https://example.com/zero#clickinfo^<goodies>;spice:fathead-\\',
        html => qr|https://example.com/zero#clickinfo\^\&lt;goodies\&gt;;spice:fathead-\\|
    ),
    'urlunescape https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22' => test_zci(
        qq`URL Decoded: https://example.org/the answer to "[life], (the universe) .and. <everything>"`,
        html => qr#https://example\.org/the answer to &quot;\[life\], \(the universe\) \.and\. &lt;everything&gt;&quot;#
    ),
    'https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22' => test_zci(
        qq`URL Decoded: https://example.org/the answer to "[life], (the universe) .and. <everything>"`,
        html => qr#https://example\.org/the answer to &quot;\[life\], \(the universe\) \.and\. &lt;everything&gt;&quot;#
    ),
    'www.heroku.com%2F%7Brawwr!%40%23%24%25%5E%26*()%2B%3D__%7D unescapeurl' => test_zci(
        'URL Decoded: www.heroku.com/{rawwr!@#$%^&*()+=__}',
        html => qr|www\.heroku\.com/\{rawwr!@#\$%\^&amp;\*\(\)\+=__\}|
    ),
    'hello there unescapeurl' => undef,
    'urldecode %3Cscript%3Ealert(1)%3C%2Fscript%3E' => test_zci(
        "URL Decoded: <script>alert(1)</script>",
        html => qr|&lt;script&gt;alert\(1\)&lt;/script&gt;|
    ),
    'https%3A%2F%2Fduckduckgo.com%2F' => test_zci(
        "URL Decoded: https://duckduckgo.com/",
        html => qr#https://duckduckgo\.com/#
    ),
    '%20' => test_zci(
        'URL Decoded: Space',
        html => qr#URL Decoded:.*Space#
    ),
    '38% of 100 GBP' => undef,
    'url decode tool' => undef,
    'url decode online' => undef
);

done_testing;
