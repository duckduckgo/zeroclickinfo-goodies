#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "hodor";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Hodor )],
    'hodor' => test_zci('Hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor Hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor hodor '),
    
    'asdf' => undef,
);

done_testing;
