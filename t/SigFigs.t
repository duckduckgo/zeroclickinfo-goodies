#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sig_figs';
zci is_cached => 1;

sub build_structured_answer {
    my ($exp_result, $exp_input) = @_;
    return $exp_result, structured_answer => {
        id   => 'sig_figs',
        name => 'Answer',
        data => {
            title    => "$exp_result",
            subtitle => "Number of Significant Figures in $exp_input",
        },
        templates => {
            group  => 'text',
            moreAt => 0,
        },
    };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::SigFigs)],
    'sf 78'                         => build_test('2', '78'),
    "sigfigs 10.12404"              => build_test('7', '10.12404'),
    "significant digits of 3030."   => build_test('4', '3,030.'),
    "significant figures 0.0100235" => build_test('6', '0.0100235'),
    "sf 302.056"                    => build_test('6', '302.056'),
    "significant figs 045.30"       => build_test('4', '045.30'),
    'sigfigs 01.1234000'            => build_test('8', '01.1234000'),
    'significant figures 000123000' => build_test('3', '000,123,000'),
    'sigfigs 0'                     => build_test('0', '0'),
    'sf 001,70'                     => build_test('3', '001,70'),
    'sf 1_200.'                     => build_test('4', '1,200.'),
    'sf 1. 5h'                      => build_test('2', '1.5'),
    'sig figs 501,.3'               => build_test('4', '501,.3'),
    'sf'                            => undef,
    'significant figures a'         => undef,
    'significant figures of 1.230'  => build_test('4', '1.230'),
    'sig figs 1h1'                  => undef,
    'sig figs 000.'                 => build_test('0', '000.'),
    'What are the significant figures of 312?' => build_test('3', '312'),
    'How many sig figs are there in 11.3'      => build_test('3', '11.3'),
);

done_testing;
