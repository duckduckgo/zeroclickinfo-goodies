#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'title_case';
zci is_cached   => 1;

sub build_test
{
    my ($text, $input) = @_;
    
    return test_zci($text, structured_answer => {
        data => {
            title => $text,
            subtitle => 'Title case: '.$input
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::TitleCase)],
    'titlecase test this out' => build_test('Test This Out', 'test this out'),
    'titlecase this is a walk in the park' => build_test('This Is a Walk in the Park', 'this is a walk in the park'),
    'titlecase a good day to die hard' => build_test('A Good Day to Die Hard', 'a good day to die hard'),
    'titlecase A GOOD DAY TO                   DIE HARD' => build_test('A Good Day to Die Hard', 'A GOOD DAY TO                   DIE HARD'),
    'titlecase here i am testing-hyphenated-words' => build_test('Here I Am Testing-Hyphenated-Words', 'here i am testing-hyphenated-words'),
    'titlecase test' => build_test('Test', 'test'),
    'how do i make something titlecase' => undef,
);

done_testing;
