#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'ascii_table';
zci is_cached   => 1;

sub build_structured_answer {
    return unless $_ eq '';

    return 'ASCII Table',
        structured_answer => {
            id => 'ascii_table',
            name => 'ASCII Table',
            data => ignore(),
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.ascii_table.content'   
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::AsciiTable )],
    'ascii table' => build_test(),
    'ascii reference table' => build_test(),
    'ascii reference' => build_test(),
    'ascii convertor' => undef,
    'ascii conversion' => undef,
    'convert ascii' => undef,
    'dont run for this' => undef
);

done_testing;
