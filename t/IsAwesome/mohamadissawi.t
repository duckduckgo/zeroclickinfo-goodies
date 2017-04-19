#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_mohamadissawi";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::mohamadissawi
    )],
    'duckduckhack mohamadissawi' => test_zci('mohamadissawi is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack mohamadissawi is awesome' => undef,
);

done_testing;
