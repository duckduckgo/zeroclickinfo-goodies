#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'dessert';
zci is_cached => 0;

ddg_goodie_test(
    [
        'DDG::Goodie::Dessert'
    ],
    'desserts beginning with a' => test_zci(
        qr/(.*?) is a dessert that begins with 'a'\.$/,
        structured_answer => {
            id => 'dessert',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'info',
            }
        }
    ),
    'desserts beginning with A' => test_zci(
        qr/(.*?) is a dessert that begins with 'A'\.$/,
        structured_answer => {
            id => 'dessert',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'info',
            }
        }
    ),
    'dessert start with a' => test_zci(
        qr/(.*?) is a dessert that begins with 'a'\.$/,
        structured_answer => {
            id => 'dessert',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'info',
            }
        }
    ),
    'desserts starting with a' => test_zci(
        qr/(.*?) is a dessert that begins with 'a'\.$/,
        structured_answer => {
            id => 'dessert',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'info',
            }
        }
    ),
    'dessert starts with a' => test_zci(
        qr/(.*?) is a dessert that begins with 'a'\.$/,
        structured_answer => {
            id => 'dessert',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'info',
            }
        }
    ),
    'desserts beginning with z' => test_zci(
        qr/(.*?) is a dessert that begins with 'z'\.$/,
        structured_answer => {
            id => 'dessert',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'info',
            }
        }
    ),
    'a dessert that begins with a' => test_zci(
        qr/(.*?) is a dessert that begins with 'a'\.$/,
        structured_answer => {
            id => 'dessert',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'info',
            }
        }
    ),
    'a dessert that starts with the letter a' => test_zci(
        qr/(.*?) is a dessert that begins with 'a'\.$/,
        structured_answer => {
            id => 'dessert',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'info',
            }
        }
    ),
    'dessert that begins with the letter z' => test_zci(
        qr/(.*?) is a dessert that begins with 'z'\.$/,
        structured_answer => {
            id => 'dessert',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'info',
            }
        }
    ),
);

done_testing;
