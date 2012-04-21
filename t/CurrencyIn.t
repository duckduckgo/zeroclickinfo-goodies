#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'currency_in';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::CurrencyIn
        )],
        'currency in australia' => test_zci('The currency in Australia is the Australian dollar (AUD)', html => 'The currency in Australia is the Australian dollar (AUD)<br />'),
);

done_testing;
