#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "phone_alphabet";
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::PhoneAlphabet )],
    '1-800-LAWYR-UP to digits' => test_zci('Phone Number: 1-800-52997-87'),
    '1-800-fun-hack to phone number' => test_zci('Phone Number: 1-800-386-4225'),
    '1958funhack to phone' => test_zci('Phone Number: 19583864225'),
    'something fun to hack to phone' => undef,
    '0x0123 to digits' => undef
);

done_testing;
