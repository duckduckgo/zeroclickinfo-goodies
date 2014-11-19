#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'pw';
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::Password)],
    'random password weak 5' => test_zci(
        qr/.{5} \(random password\)/,
        structured_answer => {
            input     => ['5 characters', 'low strength'],
            operation => 'random password',
            result    => qr/^.{5}$/
        }
    ),
    'password 5 EaSy' => test_zci(
        qr/.{5} \(random password\)/,
        structured_answer => {
            input     => ['5 characters', 'low strength'],
            operation => 'random password',
            result    => qr/^.{5}$/
        }
    ),
    'password low 5' => test_zci(
        qr/.{5} \(random password\)/,
        structured_answer => {
            input     => ['5 characters', 'low strength'],
            operation => 'random password',
            result    => qr/^.{5}$/
        }
    ),
    'pw 15 average' => test_zci(
        qr/.{15} \(random password\)/,
        structured_answer => {
            input     => ['15 characters', 'average strength'],
            operation => 'random password',
            result    => qr/^.{15}$/
        }
    ),
    'password normal 15' => test_zci(
        qr/.{15} \(random password\)/,
        structured_answer => {
            input     => ['15 characters', 'average strength'],
            operation => 'random password',
            result    => qr/^.{15}$/
        }
    ),
    'random pw 15 AVG' => test_zci(
        qr/.{15} \(random password\)/,
        structured_answer => {
            input     => ['15 characters', 'average strength'],
            operation => 'random password',
            result    => qr/^.{15}$/
        }
    ),
    'pwgen strong 25' => test_zci(
        qr/.{25} \(random password\)/,
        structured_answer => {
            input     => ['25 characters', 'high strength'],
            operation => 'random password',
            result    => qr/^.{25}$/
        }
    ),
    'password 25 hard' => test_zci(
        qr/.{25} \(random password\)/,
        structured_answer => {
            input     => ['25 characters', 'high strength'],
            operation => 'random password',
            result    => qr/^.{25}$/
        }
    ),
    'Password High 25' => test_zci(
        qr/.{25} \(random password\)/,
        structured_answer => {
            input     => ['25 characters', 'high strength'],
            operation => 'random password',
            result    => qr/^.{25}$/
        }
    ),
    # Example queries
    'random password' => test_zci(
        qr/.{8} \(random password\)/,
        structured_answer => {
            input     => ['8 characters', 'average strength'],
            operation => 'random password',
            result    => qr/^.{8}$/
        }
    ),
    'random password strong 15' => test_zci(
        qr/.{15} \(random password\)/,
        structured_answer => {
            input     => ['15 characters', 'high strength'],
            operation => 'random password',
            result    => qr/^.{15}$/
        }
    ),
);

done_testing
