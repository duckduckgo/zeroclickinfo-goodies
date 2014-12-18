#! /usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 0;
zci answer_type => "randomname";

ddg_goodie_test(
    [
        'DDG::Goodie::RandomName'
    ],
    'random Name' => test_zci (qr/\w\w \(random\)/),
    'random name' => test_zci (qr/\w\w \(random\)/),
    'random person' =>
        test_zci (qr/Name: [\w\s]+\nGender: (?:Male|Female)\nDate of birth: \d{4}\-\d{2}\-\d{2}\nAge: \d+/,
                  heading => 'Random Person'),
    'random domain name' => undef,
    'random city name' => undef,
    'names of random people' => undef
);

done_testing;
