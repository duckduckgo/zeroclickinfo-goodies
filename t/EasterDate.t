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
    'Easter 2015' => test_zci('Western: 5 April, Orthodox: 12 April',
        structured_answer => {
            input => ['2015'],
            operation => 'Easter',
            result => 'Western: 5 April, Orthodox: 12 April'
        }),
    'Easter date' => test_zci('Western: 31 March, Orthodox: 5 May',
        structured_answer => {
            input => ['2013'],
            operation => 'Easter',
            result => 'Western: 31 March, Orthodox: 5 May'
        }),
    'date of easter' => test_zci('Western: 31 March, Orthodox: 5 May',
        structured_answer => {
            input => ['2013'],
            operation => 'Easter',
            result => 'Western: 31 March, Orthodox: 5 May'
        }),
    'when is Easter' => test_zci('Western: 31 March, Orthodox: 5 May',
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
    'date of easter 2014' => test_zci('Western: 20 April, Orthodox: 20 April',
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
    'easter 1900' => test_zci('Western: 15 April, Orthodox: 22 April',
        structured_answer => {
            input => ['1900'],
            operation => 'Easter',
            result => 'Western: 15 April, Orthodox: 22 April'
        }),
    'date of easter 1951' => test_zci('Western: 25 March, Orthodox: 29 April',
        structured_answer => {
            input => ['1951'],
            operation => 'Easter',
            result => 'Western: 25 March, Orthodox: 29 April'
        }),
    'when is easter 1850' => test_zci('Western: 31 March, Orthodox: 5 May',
        structured_answer => {
            input => ['1850'],
            operation => 'Easter',
            result => 'Western: 31 March, Orthodox: 5 May'
        }),
    'when is easter 1800' => test_zci('Western: 13 April, Orthodox: 20 April',
        structured_answer => {
            input => ['1800'],
            operation => 'Easter',
            result => 'Western: 13 April, Orthodox: 20 April'
        }),
    'when is easter 1803' => test_zci('Western: 10 April, Orthodox: 17 April',
        structured_answer => {
            input => ['1803'],
            operation => 'Easter',
            result => 'Western: 10 April, Orthodox: 17 April'
        }),
    'easter 2299' => test_zci('Western: 16 April, Orthodox: 23 April',
        structured_answer => {
            input => ['2299'],
            operation => 'Easter',
            result => 'Western: 16 April, Orthodox: 23 April'
        }),
    'easter 2298' => test_zci('Western: 3 April, Orthodox: 8 May',
        structured_answer => {
            input => ['2298'],
            operation => 'Easter',
            result => 'Western: 3 April, Orthodox: 8 May'
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
    'Passover 2099' => test_zci('5 April',
        structured_answer => {
            input => ['2099'],
            operation => 'Passover',
            result => '5 April'
        }),

    'easter' => undef,
    'easter 123' => undef,
    'easter 2300' => undef,
    'easter 1799' => undef,
    'easter date 2000 date' => undef,
    'Rosh Hashanah' => undef,
    'Pesach' => undef,
    'Passover' => undef,
    'Passover 1899' => undef,
    'Rosh Hashanah 2100' => undef,
    'Jewish Holidays 9999' => undef,
    'Jewish Holidays' => undef
);

done_testing;
