#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'random_passphrase';
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::Passphrase )],
    'random passphrase 1 word'          => test_zci(qr/random passphrase:(?:\s[a-z]+)/),
    'passphrase 1 word'                 => test_zci(qr/random passphrase:(?:\s[a-z]+)/),
    'passphrase 2 random word'          => test_zci(qr/random passphrase:(?:\s[a-z]+){2}/),
    'passphrase 2 word'                 => test_zci(qr/random passphrase:(?:\s[a-z]+){2}/),
    'passphrase 3 words random'         => test_zci(qr/random passphrase:(?:\s[a-z]+){3}/),
    'pass phrase 3 random words'        => test_zci(qr/random passphrase:(?:\s[a-z]+){3}/),
    'pass phrase 3 words random'        => test_zci(qr/random passphrase:(?:\s[a-z]+){3}/),
    '3 word passphrase'                 => test_zci(qr/random passphrase:(?:\s[a-z]+){3}/),
    '3 word pass phrase random'         => test_zci(qr/random passphrase:(?:\s[a-z]+){3}/),
    '4 word random passphrase'          => test_zci(qr/random passphrase:(?:\s[a-z]+){4}/),
    'generate 4 word random passphrase' => test_zci(qr/random passphrase:(?:\s[a-z]+){4}/),
    '10 word passphrase random'         => test_zci(qr/random passphrase:(?:\s[a-z]+){10}/),
    'random passphrase'                 => test_zci(qr/random passphrase:(?:\s[a-z]+){4}/),
    'create random passphrase'          => test_zci(qr/random passphrase:(?:\s[a-z]+){4}/),
    '3 random words passphrase'         => test_zci(qr/random passphrase:(?:\s[a-z]+){3}/),
    'random 3 word pass phrase'         => test_zci(qr/random passphrase:(?:\s[a-z]+){3}/),
    'pass phrase 3 words'               => test_zci(qr/random passphrase:(?:\s[a-z]+){3}/),
    'pass phrase 0 words'               => undef,
    'passphrase 11 words'               => undef,
    'passphrase 3'                      => undef,
    'passphrase'                        => undef,
    'pass phrase 3 chars'               => undef,
    'random generate 3 word passphrase' => undef,
);

done_testing;
