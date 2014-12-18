#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'title_case';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::TitleCase)],
    'titlecase test this out' => test_zci(
        'Test This Out',
        structured_answer => {
            input     => ['test this out'],
            operation => 'title case',
            result    => 'Test This Out'
        },
    ),
    'titlecase this is a walk in the park' => test_zci(
        'This Is a Walk in the Park',
        structured_answer => {
            input     => ['this is a walk in the park'],
            operation => 'title case',
            result    => 'This Is a Walk in the Park'
        },
    ),
    'titlecase a good day to die hard' => test_zci(
        'A Good Day to Die Hard',
        structured_answer => {
            input     => ['a good day to die hard'],
            operation => 'title case',
            result    => 'A Good Day to Die Hard'
        },
    ),
    'titlecase A GOOD DAY TO                   DIE HARD' => test_zci(
        'A Good Day to Die Hard',
        structured_answer => {
            input     => ['A GOOD DAY TO                   DIE HARD'],
            operation => 'title case',
            result    => 'A Good Day to Die Hard'
        },
    ),
    'titlecase here i am testing-hyphenated-words' => test_zci(
        'Here I Am Testing-Hyphenated-Words',
        structured_answer => {
            input     => ['here i am testing-hyphenated-words'],
            operation => 'title case',
            result    => 'Here I Am Testing-Hyphenated-Words'
        },
    ),
    'titlecase test' => test_zci(
        'Test',
        structured_answer => {
            input     => ['test'],
            operation => 'title case',
            result    => 'Test'
        },
    ),
    'how do i make something titlecase' => undef,
);

done_testing;
