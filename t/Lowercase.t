#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'lowercase';
zci is_cached   => 1;

sub build_test
{
    my ($text, $subtitle) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $text,
            subtitle => $subtitle
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    ['DDG::Goodie::Lowercase'],
    'lowercase foo' => undef,
    'lowercase 123' => undef,
    'lower case foo123' => undef,
    'lower case foO' => build_test(
        'foo',
        'Lowercase: foO',
    ),
    'lowercase john Doe' => build_test(
        'john doe',
        'Lowercase: john Doe',
    ),
    'lowercase GitHub' => build_test(
        'github',
        'Lowercase: GitHub',
    ),
    'lower case GitHub' => build_test(
        'github',
        'Lowercase: GitHub',
    ),
    'lc GitHub' => build_test(
        'github',
        'Lowercase: GitHub',
    ),
    'strtolower GitHub' => build_test(
        'github',
        'Lowercase: GitHub',
    ),
    'tolower GitHub' => build_test(
        'github',
        'Lowercase: GitHub',
    ),
    'how to lowercase text' => undef
);

done_testing;
