#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "twelve_oclock";
zci is_cached   => 1;

my @noon = (
    '12:00pm is noon.',
    structured_answer => {
        input     => [],
        operation => 'midnight or noon',
        result    => '12:00pm is noon.'
    });
my @correct_noon = (
    'Yes, 12:00pm is noon.',
    structured_answer => {
        input     => [],
        operation => 'midnight or noon',
        result    => 'Yes, 12:00pm is noon.'
    });
my @wrong_noon = (
    'No, 12:00pm is noon.',
    structured_answer => {
        input     => [],
        operation => 'midnight or noon',
        result    => 'No, 12:00pm is noon.'
    });
my @midnight = (
    '12:00am is midnight.',
    structured_answer => {
        input     => [],
        operation => 'midnight or noon',
        result    => '12:00am is midnight.'
    });
my @correct_midnight = (
    'Yes, 12:00am is midnight.',
    structured_answer => {
        input     => [],
        operation => 'midnight or noon',
        result    => 'Yes, 12:00am is midnight.'
    });
my @wrong_midnight = (
    'No, 12:00am is midnight.',
    structured_answer => {
        input     => [],
        operation => 'midnight or noon',
        result    => 'No, 12:00am is midnight.'
    });

ddg_goodie_test(
    [qw( DDG::Goodie::TwelveOclock )],
    'is 1200a.m. noon'               => test_zci(@wrong_midnight),
    'is 1200pm noon?'                => test_zci(@correct_noon),
    'is 12:00 am midnight'           => test_zci(@correct_midnight),
    'is 12:00 pm midnight?'          => test_zci(@wrong_noon),
    'is 12:00 p.m. midnight?'        => test_zci(@wrong_noon),
    'is 12:00 AM midnight?'          => test_zci(@correct_midnight),
    'noon is 12:00 p.m.'             => test_zci(@correct_noon),
    'midnight is 12 AM'              => test_zci(@correct_midnight),
    'is 12:00P.M. midnight or noon?' => test_zci(@noon),
    'is 12am noon or midnight'       => test_zci(@midnight),
    'when is midnight'               => test_zci(@midnight),
    'when is noon?'                  => test_zci(@noon),
    'threat level midnight'          => undef,
    '12 midnight'                    => undef,
    'midnight movies'                => undef,
    'when is the midnight showing?'  => undef,
    'when is noon in Jakarta?'       => undef,
);

done_testing;
