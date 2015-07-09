#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_abrahimladha";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::abrahimladha
    )],
    'duckduckhack abrahimladha' => test_zci('abrahimladha is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack abrahimladha is awesome' => undef,
);
done_testing;
