#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;


# Example test
# Populate it with more useful tests
ddg_goodie_test(
        [qw(
                DDG::Goodie::%plugin_name
        )],
        'example this' => test_zci('this')
);


done_testing;
