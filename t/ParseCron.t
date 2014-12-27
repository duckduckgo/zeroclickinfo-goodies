#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'parsecron';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::ParseCron
	)],
	'crontab * */3 * * *' => test_zci(qr/^Cron will schedule the job at this frequency:\s*\n\s*\d{1,2}:\d{1,2}:\d{1,2} on \d{1,2} [a-zA-Z]{3}, \d{4}\s*\n\s*\d{1,2}:\d{1,2}:\d{1,2} on \d{1,2} [a-zA-Z]{3}, \d{4}\s*\n\s*\d{1,2}:\d{1,2}:\d{1,2} on \d{1,2} [a-zA-Z]{3}, \d{4}$/),
	'crontab 42 12 3 Feb Sat' => test_zci(qr/^Cron will schedule the job at this frequency:\s*\n\s*\d{1,2}:\d{1,2}:\d{1,2} on \d{1,2} [a-zA-Z]{3}, \d{4}\s*\n\s*\d{1,2}:\d{1,2}:\d{1,2} on \d{1,2} [a-zA-Z]{3}, \d{4}\s*\n\s*\d{1,2}:\d{1,2}:\d{1,2} on \d{1,2} [a-zA-Z]{3}, \d{4}$/),
	'crontab 42 12 3 feb sat' => test_zci(qr/^Cron will schedule the job at this frequency:\s*\n\s*\d{1,2}:\d{1,2}:\d{1,2} on \d{1,2} [a-zA-Z]{3}, \d{4}\s*\n\s*\d{1,2}:\d{1,2}:\d{1,2} on \d{1,2} [a-zA-Z]{3}, \d{4}\s*\n\s*\d{1,2}:\d{1,2}:\d{1,2} on \d{1,2} [a-zA-Z]{3}, \d{4}$/),
);

done_testing;


