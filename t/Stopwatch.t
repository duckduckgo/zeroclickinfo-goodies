#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "stopwatch";
zci is_cached   => 1;

sub build_structured_answer {
    return "",
        structured_answer => {
            templates => {
                group => 'base',
                detail => 'DDH.stopwatch.stopwatch',
                wrap_detail => 'base_detail'
            },
            meta => {
                sourceName => "Stopwatch",
                itemType => "stopwatch"
            },
            data => {}
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Stopwatch )],
    'stopwatch' => build_test(),
    'online stop watch' => build_test(),
    'stopwatch online' => build_test(),
    'chronometer' => build_test(),
    'blahblah stopwatch' => undef
);

done_testing;
