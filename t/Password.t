#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'pw';
zci is_cached => 0;

ddg_goodie_test(
    [qw(
        DDG::Goodie::Password
    )],
    'password weak 5' => test_zci( qr/.{5} \(random password\)/),
    'password 15 average' => test_zci( qr/.{15} \(random password\)/),
    'password strong 25' => test_zci( qr/.{25} \(random password\)/)
);
done_testing
