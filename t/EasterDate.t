#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockTime qw( :all );
use DDG::Test::Goodie;

zci answer_type => "easter_date";
zci is_cached   => 1;

set_fixed_time("2013-01-01T10:00:00");

ddg_goodie_test(
    [qw( DDG::Goodie::EasterDate )],
    'easter 2015' => test_zci('Western: 5 April, Orthodox: 12 April',
        structured_answer => {
            input => ['2015'],
            operation => 'Easter',
            result => 'Western: 5 April, Orthodox: 12 April'
        }),
    'easter date' => test_zci('Western: 31 March, Orthodox: 5 May',
        structured_answer => {
            input => ['2013'],
            operation => 'Easter',
            result => 'Western: 31 March, Orthodox: 5 May'
        }),
    'Easter date 1995' => test_zci('Western: 16 April, Orthodox: 23 April',
        structured_answer => {
            input => ['1995'],
            operation => 'Easter',
            result => 'Western: 16 April, Orthodox: 23 April'
        }),
    'EASTER 1995 date' => test_zci('Western: 16 April, Orthodox: 23 April',
        structured_answer => {
            input => ['1995'],
            operation => 'Easter',
            result => 'Western: 16 April, Orthodox: 23 April'
        }),
    'easter 2014' => test_zci('Western: 20 April, Orthodox: 20 April',
        structured_answer => {
            input => ['2014'],
            operation => 'Easter',
            result => 'Western: 20 April, Orthodox: 20 April'
        }),
    'Easter 2016' => test_zci('Western: 27 March, Orthodox: 1 May',
        structured_answer => {
            input => ['2016'],
            operation => 'Easter',
            result => 'Western: 27 March, Orthodox: 1 May'
        }),
        
    'catholic easter 2016' => test_zci('27 March',
        structured_answer => {
            input => ['2016'],
            operation => 'Catholic Easter',
            result => '27 March'
        }),
    'protestant easter 2016' => test_zci('27 March',
        structured_answer => {
            input => ['2016'],
            operation => 'Protestant Easter',
            result => '27 March'
        }),
    'orthodox easter 2016' => test_zci('1 May',
        structured_answer => {
            input => ['2016'],
            operation => 'Orthodox Easter',
            result => '1 May'
        }),
    
    'Passover 2015' => test_zci('4 April',
        structured_answer => {
            input => ['2015'],
            operation => 'Passover',
            result => '4 April'
        }),
    'Pesach 2015' => test_zci('4 April',
        structured_answer => {
            input => ['2015'],
            operation => 'Pesach',
            result => '4 April'
        }),
    'Rosh Hashanah 2014' => test_zci('25 September',
        structured_answer => {
            input => ['2014'],
            operation => 'Rosh Hashanah',
            result => '25 September'
        }),
    'Jewish Holidays 2014' => test_zci('Rosh Hashanah: 25 September, Passover: 15 April',
        structured_answer => {
            input => ['2014'],
            operation => 'Jewish Holidays',
            result => 'Rosh Hashanah: 25 September, Passover: 15 April'
        }),

    'easter' => undef,
    'easter 123' => undef,
    'easter date 2000 date' => undef,
    'Rosh Hashanah' => undef,
    'Pesach' => undef,
    'Passover' => undef,
    'Jewish Holidays' => undef
);

done_testing;
