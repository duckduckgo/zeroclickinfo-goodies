#! /usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'rand';
zci is_cached => 0;

ddg_goodie_test(
    [
        'DDG::Goodie::RandomPerson'
    ],
    'random name'   => test_zci (qr/\w+ \w+/),
    'random Name'   => test_zci (qr/\w+ \w+/),
    'random person' => test_zci (qr/\w+\. \w+ \w+, born \d+-\d+-\d+/),
    'random Person' => test_zci (qr/\w+\. \w+ \w+, born \d+-\d+-\d+/),


);

done_testing;