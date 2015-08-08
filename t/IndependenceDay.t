#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "independence_day";
zci is_cached   => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::IndependenceDay
	)],
	# primary example queries
	'what is the independence day of norway' => test_zci(
		'Independence Day of Norway May 17th, 1814',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Norway',
			result    => 'May 17th, 1814',
		}
	),
	'independence day, papua new guinea' => test_zci(
		'Independence Day of Papua New Guinea September 16th, 1975',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Papua New Guinea',
			result    => 'September 16th, 1975',
		}
	),

	# question marks
	'what is the independence day of norway?' => test_zci(
		'Independence Day of Norway May 17th, 1814',
		structured_answer =>{
			input     => [],
			operation => 'Independence Day of Norway',
			result    => 'May 17th, 1814',
		}
	),
	# some aliases
	'when is the independence day of republic of congo' => test_zci(
		'Independence Day of Republic of the Congo August 15th, 1960',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Republic of the Congo',
			result    => 'August 15th, 1960',
		}
	),
	'when is the independence day of republic of the congo' => test_zci(
		'Independence Day of Republic of the Congo August 15th, 1960',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Republic of the Congo',
			result    => 'August 15th, 1960',
		}
	),
	'gambia independence day' => test_zci(
		'Independence Day of The Gambia February 18th, 1965',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of The Gambia',
			result    => 'February 18th, 1965',
		}
	),
	'the gambia independence day' => test_zci(
		'Independence Day of The Gambia February 18th, 1965',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of The Gambia',
			result    => 'February 18th, 1965',
		}
	),
	'usa independence day' => test_zci(
		'Independence Day of United States of America July 4th, 1776',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of United States of America',
			result    => 'July 4th, 1776',
		}
	),
	# data points with two dates
	'independence day of panama' => test_zci(
		'Independence Day of Panama November 28th, 1821 and November 3rd, 1903',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Panama',
			result    => 'November 28th, 1821 and November 3rd, 1903',
		}
	),
	'independence day of armenia' => test_zci(
		'Independence Day of Armenia May 28th, 1918 and September 21th, 1991',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Armenia',
			result    => 'May 28th, 1918 and September 21th, 1991',
		}
	),
	# miscellaneous
	'independence day of papua new guinea' => test_zci(
		'Independence Day of Papua New Guinea September 16th, 1975',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Papua New Guinea',
			result    => 'September 16th, 1975',
		}
	),
	'day of independence of sri lanka' => test_zci(
		'Independence Day of Sri Lanka February 4th, 1948',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Sri Lanka',
			result    => 'February 4th, 1948',
		}
	),
	'when is the day of independence for norway' => test_zci(
		'Independence Day of Norway May 17th, 1814',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Norway',
			result    => 'May 17th, 1814',
		}
	),
	'day of independence, norway' => test_zci(
		'Independence Day of Norway May 17th, 1814',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Norway',
			result    => 'May 17th, 1814',
		}
	),
	'norway independence day' => test_zci(
		'Independence Day of Norway May 17th, 1814',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Norway',
			result    => 'May 17th, 1814',
		}
	),
	'what day is the independence day of norway' => test_zci(
		'Independence Day of Norway May 17th, 1814',
		structured_answer => {
			input     => [],
			operation => 'Independence Day of Norway',
			result    => 'May 17th, 1814',
		}
	),

);

done_testing;
