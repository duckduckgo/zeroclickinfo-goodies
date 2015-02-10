#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "pi";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Pi )],
    'pi 7' => test_zci('3.1415926'),

    'pi 23 digit' => undef
);

done_testing;
