#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "lorem_ipsum";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::LoremIpsum )]
);

done_testing;
