#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'uppercase';
zci is_cached   => 1;

sub build_test 
{
    my ($text, $subtitle) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $text,
            subtitle => "Uppercase: $subtitle"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Uppercase)],
    'upper case this' => build_test('THIS', 'this'),
    'uppercase that' => build_test('THAT', 'that'),
    'allcaps this string' => build_test('THIS STRING','this string'),
    'that string all caps'    => undef,
    'is this uppercase, sir?' => undef,
    'uppercase HELLO'         => undef,
    'uppercase 123'           => undef
);

done_testing;
