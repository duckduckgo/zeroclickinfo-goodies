#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'pw';
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::Password)],
    'pw 15 average' => test_zci(
        qr/.{15} \(random password\)/,
        structured_answer => {
            input     => ['15 characters', 'average strength'],
            operation => 'Random password',
            result    => qr/^.{15}$/
        }
    ),
    'password normal 15' => test_zci(
        qr/.{15} \(random password\)/,
        structured_answer => {
            input     => ['15 characters', 'average strength'],
            operation => 'Random password',
            result    => qr/^.{15}$/
        }
    ),
    'random pw 15 AVG' => test_zci(
        qr/.{15} \(random password\)/,
        structured_answer => {
            input     => ['15 characters', 'average strength'],
            operation => 'Random password',
            result    => qr/^.{15}$/
        }
    ),
    'pwgen strong 25' => test_zci(
        qr/.{25} \(random password\)/,
        structured_answer => {
            input     => ['25 characters', 'high strength'],
            operation => 'Random password',
            result    => qr/^.{25}$/
        }
    ),
    'password 25 hard' => test_zci(
        qr/.{25} \(random password\)/,
        structured_answer => {
            input     => ['25 characters', 'high strength'],
            operation => 'Random password',
            result    => qr/^.{25}$/
        }
    ),
    'Password High 25' => test_zci(
        qr/.{25} \(random password\)/,
        structured_answer => {
            input     => ['25 characters', 'high strength'],
            operation => 'Random password',
            result    => qr/^.{25}$/
        }
    ),
    # Example queries
    'random password' => test_zci(
        qr/.{8} \(random password\)/,
        structured_answer => {
            input     => ['8 characters', 'average strength'],
            operation => 'Random password',
            result    => qr/^.{8}$/
        }
    ),
    'password strong 15' => test_zci(
        qr/.{15} \(random password\)/,
        structured_answer => {
            input     => ['15 characters', 'high strength'],
            operation => 'Random password',
            result    => qr/^.{15}$/
        }
    ),
    'pw' => test_zci(
        qr/.{8} \(random password\)/,
        structured_answer => {
            input     => ['8 characters', 'average strength'],
            operation => 'Random password',
            result    => qr/^.{8}$/
        }
    ),
    # Add some triggers (issue  #1565)
    'generate password' => test_zci(
        qr/.{8} \(random password\)/,
        structured_answer => {
            input     => ['8 characters', 'average strength'],
            operation => 'Random password',
            result    => qr/^.{8}$/
        }
    ),
    'generate strong password' => test_zci(
        qr/.{8} \(random password\)/,
        structured_answer => {
            input     => ['8 characters', 'high strength'],
            operation => 'Random password',
            result    => qr/^.{8}$/
        }
    ),
    'generate random password' => test_zci(
        qr/.{8} \(random password\)/,
        structured_answer => {
            input     => ['8 characters', 'average strength'],
            operation => 'Random password',
            result    => qr/^.{8}$/
        }
    ),
    'password generator' => test_zci(
        qr/.{8} \(random password\)/,
        structured_answer => {
            input     => ['8 characters', 'average strength'],
            operation => 'Random password',
            result    => qr/^.{8}$/
        }
    ),
    'random password generator' => test_zci(
        qr/.{8} \(random password\)/,
        structured_answer => {
            input     => ['8 characters', 'average strength'],
            operation => 'Random password',
            result    => qr/^.{8}$/
        }
    ),
    'random strong password' => test_zci(
        qr/.{8} \(random password\)/,
        structured_answer => {
            input     => ['8 characters', 'high strength'],
            operation => 'Random password',
            result    => qr/^.{8}$/
        }
    ),
    'random password 16 characters' => test_zci(
        qr/.{16} \(random password\)/,
        structured_answer => {
            input     => ['16 characters', 'average strength'],
            operation => 'Random password',
            result    => qr/^.{16}$/
        }
    ),
    'create random password' => test_zci(
        qr/.{8} \(random password\)/,
        structured_answer => {
            input     => ['8 characters', 'average strength'],
            operation => 'Random password',
            result    => qr/^.{8}$/
        }
    ),
    'strong random password' => test_zci(
        qr/.{8} \(random password\)/,
        structured_answer => {
            input     => ['8 characters', 'high strength'],
            operation => 'Random password',
            result    => qr/^.{8}$/
        }
    ),
    'random password strong 15' => test_zci(
        qr/.{15} \(random password\)/,
        structured_answer => {
            input     => ['15 characters', 'high strength'],
            operation => 'Random password',
            result    => qr/^.{15}$/
        }
    ),
    'password 65' => undef,
    'random password weak 5' => undef,
    'password 5 EaSy' => undef,
    'password low 5' => undef,
    'generate generate password' => undef,
    'password pw' => undef,
    'password fortissimo' => undef,
    'nice random password' => undef,
    'excavate strong password' => undef,
    'not another strong pw' => undef,
    'generator' => undef,
    'potatoe generator' => undef
);

done_testing
