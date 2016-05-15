#!/usr/bin/env perl

use strict;
use warnings;
use Test::Deep;
use Test::More;
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

ddg_goodie_test([qw( DDG::Goodie::GUID ) ],

    # Check that the trigger kicks in.
    'guid'                       => test_zci(build_structured_answer()),
    'uuid'                       => test_zci(build_structured_answer()),
    'globally unique identifier' => test_zci(build_structured_answer()),
    'rfc 4122'                   => test_zci(build_structured_answer()),
    'new guid'                   => test_zci(build_structured_answer()),
    'random uuid'                => test_zci(build_structured_answer()),
    'generate new uuid'          => test_zci(build_structured_answer()),
    'generate random uuid'       => test_zci(build_structured_answer()),
    'uuid in ansi C'             => undef,
    'what is a guid'             => undef,
);

done_testing;
