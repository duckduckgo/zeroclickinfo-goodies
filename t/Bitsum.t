#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "bitsum";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Bitsum )],
    'bitsum 127' => test_zci('7',
            structured_answer => {
                input     => ['127'],
                operation => 'Hamming Weight',
                result    => '7'
        }),
    'bitsum of 127' => test_zci('7',
            structured_answer => {
                input     => ['127'],
                operation => 'Hamming Weight',
                result    => '7'
        }),
    'bitsum 0b1111111' => test_zci('7',
            structured_answer => {
                input     => ['0b1111111'],
                operation => 'Hamming Weight',
                result    => '7'
        }),
    'bitsum for 0x1234' => test_zci('5',
            structured_answer => {
                input     => ['0x1234'],
                operation => 'Hamming Weight',
                result    => '5'
        }), 
    'hammingweight 1024' => test_zci('1',
            structured_answer => {
                input     => ['1024'],
                operation => 'Hamming Weight',
                result    => '1'
        }),
    'hammingweight 0b10101' => test_zci('3',
            structured_answer => {
                input     => ['0b10101'],
                operation => 'Hamming Weight',
                result    => '3'
        }),
    'hw 0xff' => test_zci('8',
            structured_answer => {
                input     => ['0xff'],
                operation => 'Hamming Weight',
                result    => '8'
        }),
    'hw for 0xaa' => test_zci('4',
            structured_answer => {
                input     => ['0xaa'],
                operation => 'Hamming Weight',
                result    => '4'
        }),
    'hw for 0b11' => test_zci('2',
            structured_answer => {
                input     => ['0b11'],
                operation => 'Hamming Weight',
                result    => '2'
        }),
    # Long number tests
    'hw 123456789123456789123456789' => test_zci('50',
            structured_answer => {
                input     => ['123456789123456789123456789'],
                operation => 'Hamming Weight',
                result    => '50'
        }),
    'bitsum 0x123456789ABCDEF123456789ABCDEF' => test_zci('64',
            structured_answer => {
                input     => ['0x123456789ABCDEF123456789ABCDEF'],
                operation => 'Hamming Weight',
                result    => '64'
        }),
    # Tests which should fail
    'bitsum 213f3a', undef,
    'hw 0d23238', undef,
    'bitsum 0x' => undef,
    'bitsum test' => undef,
    'bitsum 0b' => undef,
);

done_testing;
