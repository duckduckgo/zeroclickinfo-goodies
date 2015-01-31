#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'regexp';
zci is_cached   => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::Regexp )],
        'regexp /(hello\s)/ hello probably' => test_zci(
        	"hello ",
        	heading => 'Regexp Result',
        ),
        'regexp /(dd)/ ddg' => test_zci(
        	"dd",
        	heading => 'Regexp Result',
        ),
        'regex /(poss)/ many possibilities' => test_zci(
        	"poss",
        	heading => 'Regexp Result',
        ),
        'regexp /(.*)/ ddg' => test_zci(
            'ddg',
            heading => 'Regexp Result'
        ),
);

done_testing;

