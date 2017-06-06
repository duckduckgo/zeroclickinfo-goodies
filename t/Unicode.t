#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'unicode_conversion';
zci is_cached => 1;

sub build_unicode_answer {
    my @test_params = @_;

    return re(qr/^(?!\s*$).+/),
        structured_answer => {
            data => {
                title => re(qr/\w\w/),
                subtitle => re(qr/\w\w/)
            },
            templates => {
                group => "text",
            }
        };
}

sub build_unicode_test { test_zci(build_unicode_answer(@_)) }

ddg_goodie_test(
    [
        'DDG::Goodie::Unicode'
    ],
    'U+263A' => build_unicode_test(),
    'U+007E' => build_unicode_test(),
    'U+00AA' => build_unicode_test(),
    'U+00E6' => build_unicode_test(),
    'U+0100' => build_unicode_test(),
    'U+011F' => build_unicode_test(),
    'U+016A' => build_unicode_test(),
);

done_testing;
