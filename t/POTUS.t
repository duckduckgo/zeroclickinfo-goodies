#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'potus';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::POTUS
	)],
	'who is president of the united states' => test_zci(
        'Barack Obama is the 44th President of the United States.',
        html => '<a href="https://en.wikipedia.org/wiki/Barack%20Obama">Barack Obama</a> is the 44th President of the United States.'),
	'who is the fourth president of the united states' => test_zci(
        'James Madison was the 4th President of the United States.',
        html => '<a href="https://en.wikipedia.org/wiki/James%20Madison">James Madison</a> was the 4th President of the United States.'),
	'who is the nineteenth president of the united states' => test_zci(
        'Rutherford B. Hayes was the 19th President of the United States.',
        html => '<a href="https://en.wikipedia.org/wiki/Rutherford%20B.%20Hayes">Rutherford B. Hayes</a> was the 19th President of the United States.'),
		
	'who was the 1st president of the united states' => test_zci(
        'George Washington was the 1st President of the United States.',
        html => '<a href="https://en.wikipedia.org/wiki/George%20Washington">George Washington</a> was the 1st President of the United States.'),
	'who was the 31 president of the united states' => test_zci(
        'Herbert Hoover was the 31st President of the United States.',
        html => '<a href="https://en.wikipedia.org/wiki/Herbert%20Hoover">Herbert Hoover</a> was the 31st President of the United States.'),
	'who was the 22 president of the united states' => test_zci(
        'Grover Cleveland was the 22nd President of the United States.',
        html => '<a href="https://en.wikipedia.org/wiki/Grover%20Cleveland">Grover Cleveland</a> was the 22nd President of the United States.'),
	'potus 11' => test_zci(
        'James K. Polk was the 11th President of the United States.',
        html => '<a href="https://en.wikipedia.org/wiki/James%20K.%20Polk">James K. Polk</a> was the 11th President of the United States.'),
	'POTUS 24', => test_zci(
        'Grover Cleveland was the 24th President of the United States.',
        html => '<a href="https://en.wikipedia.org/wiki/Grover%20Cleveland">Grover Cleveland</a> was the 24th President of the United States.'),


);

done_testing;
