#! /usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'email_validation';
zci is_cached   => 1;

ddg_goodie_test(
    ['DDG::Goodie::EmailValidator'],
    'validate my email foo@example.com' => test_zci(
        qr/appears to be valid/,
        structured_answer => {
            input     => ['foo@example.com'],
            operation => 'email address validation',
            result    => qr/appears to be valid/
        }
    ),
    'validate my email foo+abc@example.com' => test_zci(
        qr/appears to be valid/,
        structured_answer => {
            input     => ['foo+abc@example.com'],
            operation => 'email address validation',
            result    => qr/appears to be valid/
        }
    ),
    'validate my email foo.bar@example.com' => test_zci(
        qr/appears to be valid/,
        structured_answer => {
            input     => ['foo.bar@example.com'],
            operation => 'email address validation',
            result    => qr/appears to be valid/
        }
    ),
    'validate user@exampleaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com'
      => test_zci(
        qr/Please check the address/,
        structured_answer => {
            input     => '-ANY-',
            operation => 'email address validation',
            result    => qr/Please check the address/,
        }
      ),
    'validate foo@example.com' => test_zci(
        qr/appears to be valid/,
        structured_answer => {
            input     => ['foo@example.com'],
            operation => 'email address validation',
            result    => qr/appears to be valid/
        }
    ),
    'validate foo@!!!.com' => test_zci(
        qr/Please check the fully qualified domain name/,
        structured_answer => {
            input     => ['foo@!!!.com'],
            operation => 'email address validation',
            result    => qr/Please check the fully qualified domain name/,
        }
    ),
    'validate foo@example.lmnop' => test_zci(
        qr/Please check the top-level domain/,
        structured_answer => {
            input     => ['foo@example.lmnop'],
            operation => 'email address validation',
            result    => qr/Please check the top-level domain/,
        }
    ),
    'validate foo'                      => undef,
);

done_testing;
