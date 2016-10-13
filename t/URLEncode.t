#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use Test::Deep;
use HTML::Entities;
use DDG::Test::Goodie;

zci answer_type => 'encoded_url';
zci is_cached   => 1;

sub build_answer {
    my ($answer, $sub) = @_;
    $sub = '' unless $sub;

    return sprintf("Percent-encoded URL: %s",$answer) , structured_answer => {
        data => {
            title => $answer,
            subtitle => "URL percent-encode: $sub"
        },
        templates => {
            group => 'text',
            moreAt => 0
        }
    }
}

ddg_goodie_test(
    [qw(DDG::Goodie::URLEncode)],

    # Primary example queries
    'url encode https://duckduckgo.com/' => test_zci(build_answer('https%3A%2F%2Fduckduckgo.com%2F', 'https://duckduckgo.com/')),

    'uri encode https://duckduckgo.com/' => test_zci(build_answer('https%3A%2F%2Fduckduckgo.com%2F', 'https://duckduckgo.com/')),

    'encode url xkcd.com/blag' => test_zci(build_answer('xkcd.com%2Fblag', 'xkcd.com/blag')),

    'encode uri xkcd.com/blag' => test_zci(build_answer('xkcd.com%2Fblag', 'xkcd.com/blag')),

    # Secondary example queries
    'http://arstechnica.com/ url escape' => test_zci(build_answer('http%3A%2F%2Farstechnica.com%2F', 'http://arstechnica.com/')),

    'apple.com/mac/ escape url' => test_zci(build_answer('apple.com%2Fmac%2F', 'apple.com/mac/')),

    'urlencode www.xkcd.com/a-webcomic-of-romance+math+sarcasm+language' => test_zci(build_answer('www.xkcd.com%2Fa-webcomic-of-romance%2Bmath%2Bsarcasm%2Blanguage', 'www.xkcd.com/a-webcomic-of-romance+math+sarcasm+language')),

    'https://example.com/zero#clickinfo^<goodies>;spice:fathead-\ encodeurl' => test_zci(build_answer('https%3A%2F%2Fexample.com%2Fzero%23clickinfo%5E%3Cgoodies%3E%3Bspice%3Afathead-%5C', 'https://example.com/zero#clickinfo^<goodies>;spice:fathead-\\')),

    'urlescape https://example.org/the answer to "[life], (the universe) .and. <everything>"' => test_zci(build_answer('https%3A%2F%2Fexample.org%2Fthe%20answer%20to%20%22%5Blife%5D%2C%20(the%20universe)%20.and.%20%3Ceverything%3E%22', 'https://example.org/the answer to "[life], (the universe) .and. <everything>"')),

    'www.heroku.com/{rawwr!@#$%^&*()+=__} escapeurl' => test_zci(build_answer('www.heroku.com%2F%7Brawwr!%40%23%24%25%5E%26*()%2B%3D__%7D', 'www.heroku.com/{rawwr!@#$%^&*()+=__}')),

    'äöü escapeurl' => test_zci(build_answer('%E4%F6%FC', 'äöü')),

    'hello there escapeurl' => test_zci(build_answer('hello%20there', 'hello there')),
);

done_testing;
