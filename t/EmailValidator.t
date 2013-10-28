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
    'validate my email foo+abc@example.com' => test_zci (qr/seems to be valid/),
    'validate my email foo.bar@example.com' => test_zci (qr/seems to be valid/),
    'validate user@exampleaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com' => test_zci (qr/Please check the address/),
    'validate foo@example.com' => test_zci (qr/seems to be valid/),
    'validate customer/department=shipping@example.com' => test_zci (qr/seems to be valid/),
    'validate foo@!!!.com' => test_zci(qr/Please check the fully qualified domain name/),
    'validate foo@example.xyz' => test_zci(qr/Please check the top-level domain/),
);

done_testing;
