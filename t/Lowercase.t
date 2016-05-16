#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'lowercase';
zci is_cached   => 1;

sub build_test
{
    my ($text, $subtitle) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $text,
            subtitle => "Lowercase: $subtitle"
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
    'lower case foO' => build_test('foo', 'foO'),
    'lowercase john Doe' => build_test('john doe', 'john Doe'),
    'lowercase GitHub' => build_test('github', 'GitHub'),
    'lower case GitHub' => build_test('github', 'GitHub'),
    'lc GitHub' => build_test('github', 'GitHub'),
    'strtolower GitHub' => build_test('github', 'GitHub'),
    'tolower GitHub' => build_test('github', 'GitHub'),
    'how to lowercase text' => undef
);

done_testing;
