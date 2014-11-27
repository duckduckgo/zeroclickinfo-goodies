#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "simpleencryptionservice";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::SimpleEncryptionService::Crypto
    )],
    'rc4 decrypt hello Yz7Tmw==' => test_zci('Decrypted string: lola'),
    'rc4 ' => undef,
);

done_testing; 