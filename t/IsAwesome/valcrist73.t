#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_valcrist73";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::valcrist73
    )],
    'duckduckhack valcrist73' => test_zci('Valcrist73 is awesome and has successfully completed the DuckDuckHack Goodie tutorial! - Valcrist73 es genial y ha completado exitosamente el tutorial DuckDuckHack Goodie!'),
    'duckduckhack valcrist73 is awesome' => undef,
);

done_testing;
