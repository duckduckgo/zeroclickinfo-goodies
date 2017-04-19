#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "square_root";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::SquareRoot )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'sqrt 4' => test_zci("Square Root: 2", html => qr/Square Root:/),
    'sqrt here go' => test_zci("Square Root: 0", html => qr/Square Root:/),
);

done_testing;
