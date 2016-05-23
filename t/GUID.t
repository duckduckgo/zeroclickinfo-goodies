#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'guid';
zci is_cached => 0;

sub build_structured_answer {
    return re(qr/^([a-zA-Z]|\d){8}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){12}$/),
        structured_answer => {
            data => {
                title => re(qr/^([a-zA-Z]|\d){8}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){12}$/),
                subtitle => 'Random GUID',
            },
            templates => {
                group => 'text',
            },
        },
}

sub build_test {
    return test_zci(build_structured_answer());
}

ddg_goodie_test([qw( DDG::Goodie::GUID ) ],

    # Check that the trigger kicks in.
    'guid'                       => build_test(),
    'uuid'                       => build_test(),
    'globally unique identifier' => build_test(),
    'rfc 4122'                   => build_test(),
    'new guid'                   => build_test(),
    'random uuid'                => build_test(),
    'generate new uuid'          => build_test(),
    'generate random uuid'       => build_test(),
    'uuid in ansi C'             => undef,
    'what is a guid'             => undef,
);

done_testing;
