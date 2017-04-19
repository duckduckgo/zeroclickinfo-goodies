#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "package_tracking";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::PackageTracking )],

    #'example query' => test_zci('query'),

    'bad example query' => undef,
);

done_testing;
