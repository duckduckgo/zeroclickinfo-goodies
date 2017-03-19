#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use Test::Deep;
use HTML::Entities;
use DDG::Test::Goodie;

zci answer_type => 'decoded_url';
zci is_cached   => 1;

sub build_answer {
    my ($answer, $sub) = @_;
    $sub = '' unless $sub;

    return sprintf("URL Decoded: %s",$answer) , structured_answer => {
        data => {
            title => $answer,
            subtitle => "URL decode: $sub"
        },
        templates => {
            group => 'text',
            moreAt => 0
        }
    }
}

ddg_goodie_test(
    [qw(DDG::Goodie::URLDecode)],

    # Primary example queries
    'url decode https%3A%2F%2Fduckduckgo.com%2F' => test_zci(build_answer('https://duckduckgo.com/', 'https%3A%2F%2Fduckduckgo.com%2F')),

    'decode url xkcd.com%2Fblag' => test_zci(build_answer('xkcd.com/blag', 'xkcd.com%2Fblag')),

    # Secondary example queries
    'http%3A%2F%2Farstechnica.com%2F url unescape' => test_zci(build_answer('http://arstechnica.com/', 'http%3A%2F%2Farstechnica.com%2F')),
    'linux.com%2Ftour%2F unescape url' => test_zci(build_answer('linux.com/tour/', 'linux.com%2Ftour%2F')),
    'urldecode www.xkcd.com%2Fa-webcomic-of-romance%2Bmath%2Bsarcasm%2Blanguage' => test_zci(build_answer('www.xkcd.com/a-webcomic-of-romance+math+sarcasm+language', 'www.xkcd.com%2Fa-webcomic-of-romance%2Bmath%2Bsarcasm%2Blanguage')),
    'unescapeurl https%3A%2F%2Fexample.com%2Fzero%23clickinfo%5E%3Cgoodies%3E%3Bspice%3Afathead-%5C' => test_zci(build_answer('https://example.com/zero#clickinfo^<goodies>;spice:fathead-\\', 'https%3A%2F%2Fexample.com%2Fzero%23clickinfo%5E%3Cgoodies%3E%3Bspice%3Afathead-%5C')),
    'urlunescape https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22' => test_zci(build_answer('https://example.org/the answer to "[life], (the universe) .and. <everything>"', 'https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22')),
    'https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22' => test_zci(build_answer('https://example.org/the answer to "[life], (the universe) .and. <everything>"', 'https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22')),
    'www.heroku.com%2F%7Brawwr!%40%23%24%25%5E%26*()%2B%3D__%7D unescapeurl' => test_zci(build_answer('www.heroku.com/{rawwr!@#$%^&*()+=__}', 'www.heroku.com%2F%7Brawwr!%40%23%24%25%5E%26*()%2B%3D__%7D')),
    'urldecode %3Cscript%3Ealert(1)%3C%2Fscript%3E' => test_zci(build_answer('<script>alert(1)</script>', '%3Cscript%3Ealert(1)%3C%2Fscript%3E')),
    'https%3A%2F%2Fduckduckgo.com%2F' => test_zci(build_answer('https://duckduckgo.com/', 'https%3A%2F%2Fduckduckgo.com%2F')),
    '%E4%F6%FC' => test_zci(build_answer('äöü', '%E4%F6%FC')),
    '%20' => test_zci(build_answer('Space', '%20')),
    'uridecode 1%2B1' => test_zci(build_answer('1+1', '1%2B1')),
    'uri decode 127.0.0.1%3A80' => test_zci(build_answer('127.0.0.1:80', '127.0.0.1%3A80')),
    'URL decode hello%20there' => test_zci(build_answer('hello there', 'hello%20there')),
    'URI Decode hello%20there' => test_zci(build_answer('hello there', 'hello%20there')),
    'hello there unescapeurl' => undef,
    '38% of 100 GBP'          => undef,
    'url decode tool'         => undef,
    'url decode online'       => undef
);

done_testing;
