#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "lorem_ipsum";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::LoremIpsum )],
    'lorem ipsssum 3' => undef,
    'lorem dipsum' => undef,
    'lipsum 10' => test_zci(
        qr/[a-zA-Z .]+/,
        make_structured_answer()
    ),
    'lorem ipsum 10' => test_zci(
        qr/[a-zA-Z .]+/,
        make_structured_answer()
    ),
    'lipsum 100' => test_zci(
        qr/[a-zA-Z .]+/,
        make_structured_answer()
    ),
    'lipsum 1' => test_zci(
        qr/[a-zA-Z .]+/,
        make_structured_answer()
    ),
    'lorem ipsum 0' => test_zci(
        qr/[a-zA-Z .]+/,
        make_structured_answer()
    ),
    'lipsum' => test_zci(
        qr/[a-zA-Z .]+/,
        make_structured_answer()
    ),
    'lorem ipsum' => test_zci(
        qr/[a-zA-Z .]+/,
        make_structured_answer()
    )

);

sub make_structured_answer {
    return structured_answer => {
        id => 'lorem_ipsum',
        name => 'Answer',
        data => "-ANY-",
        meta => {
            sourceName => "Lipsum",
            sourceUrl => "http://lipsum.com/"
        },
        templates => {
            group => 'text',
            options => {
                subtitle_content => 'DDH.lorem_ipsum.subtitle',
                content => 'DDH.lorem_ipsum.content',
                moreAt => 1
            }
        }
    };
};

done_testing;