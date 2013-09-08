#! /usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'emailvalidator';
zci is_cached => 0;

ddg_goodie_test(
    [
        'DDG::Goodie::EmailValidator'
    ],
    'validate foo' => undef,
    'validate my email foo@example.com' => test_zci (qr/seems to be valid/),
    'validate foo@example.com' => test_zci (qr/seems to be valid/),
    'validate foo@!!!.com' => test_zci(qr/is not valid/),
    'validate foo@zzzyyy6yyyxxxx5zzz9zz.org' => test_zci(qr/please check the hostname/),
    'validate foo@example.xyz' => test_zci(qr/please check the top-level domain/),
);

done_testing;
