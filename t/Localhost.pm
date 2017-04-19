#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'localhost';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Localhost
        )],
        'localhost' => test_zci('<a href="http://localhost">http://localhost</a>'),
);

done_testing;

