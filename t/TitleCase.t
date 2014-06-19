#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'title_case';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::TitleCase
	)],
	'titlecase test this out' => test_zci('Test This Out'),
	'titlecase this is a walk in the park' => test_zci('This Is a Walk in the Park'),
	'titlecase a good day to die hard' => test_zci('A Good Day to Die Hard'),
	'titlecase here i am testing-hyphenated-words' => test_zci('Here I Am Testing-Hyphenated-Words'),
        'capitalize this should be capitalized' => test_zci('This Should Be Capitalized'),
    'titlecase test' => test_zci('Test'),
);

done_testing;
