#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'passphrase';
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::Passphrase )],
    'passphrase 1 word'   => test_zci(qr/random passphrase: ([a-z]+)/),
    'passphrase 2 word'   => test_zci(qr/random passphrase: ([a-z]+){2}/),
    'passphrase 3 words'  => test_zci(qr/random passphrase: ([a-z]+){3}/),
    'pass phrase 3 words' => test_zci(qr/random passphrase: ([a-z]+){3}/),
    'pass phrase 0 words' => undef,
    'passphrase 11 words' => undef,
    'passphrase 3'        => undef,
    'pass phrase 3 chars' => undef,
);

done_testing;
