#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_dronov";
zci is_cached   => 1;

ddg_goodie_test(
  [qw(
        DDG::Goodie::IsAwesome::Dronov
    )],
    'duckduckhack Dronov' => test_zci('Mikhail Dronov is awesome and has successfully completed the DuckDuckHack Goodie tutorial! He\'s saying hello from far cold Russia. Find him at dronov.net'),
    'duckduckhack dronov is awesome' => undef,
);

done_testing;
