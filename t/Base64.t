#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Base
        )],
        '10 in base 3' => test_zci('10 in base 3 is 101'),
);

done_testing;
