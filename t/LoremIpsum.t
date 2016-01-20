#!/usr/bin/env perl

use Test::Deep;
use Test::More;
use DDG::Test::Goodie;

use strict;
use warnings;

zci answer_type => "lorem_ipsum";
zci is_cached   => 1;

sub get_sa {
    return structured_answer => {
        id => 'lorem_ipsum',
        name => 'Answer',
        data => {
            is_default  => code(\&undef_or_one),
            is_plural   => code(\&undef_or_one),
            lorem_array => array_each(re(qr/\w+/)),
            title       => 'Lorem Ipsum'
        },
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
}

sub undef_or_one { my $x = shift; !defined($x) || $x == 1 }

ddg_goodie_test(
    [qw( DDG::Goodie::LoremIpsum )],
    'lorem ipsssum 3' => undef,
    'lorem dipsum' => undef,
    'lipsum 10' => test_zci(
        qr/[a-zA-Z .]+/,
        get_sa()
    ),
    'lorem ipsum 10' => test_zci(
        qr/[a-zA-Z .]+/,
        get_sa()
    ),
    'lipsum 100' => test_zci(
        qr/[a-zA-Z .]+/,
        get_sa()
    ),
    'lipsum 1' => test_zci(
        qr/[a-zA-Z .]+/,
        get_sa()
    ),
    'lorem ipsum 0' => test_zci(
        qr/[a-zA-Z .]+/,
        get_sa()
    ),
    'lipsum' => test_zci(
        qr/[a-zA-Z .]+/,
        get_sa()
    ),
    'lorem ipsum' => test_zci(
        qr/[a-zA-Z .]+/,
        get_sa()
    )

);

done_testing;
