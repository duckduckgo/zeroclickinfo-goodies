#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_the_adam_galloway";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::TheAdamGalloway )],
    'duckduckhack TheAdamGalloway' => test_zci('TheAdamGalloway is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack TheAdamGalloway is awesome' => undef,
);

done_testing;
