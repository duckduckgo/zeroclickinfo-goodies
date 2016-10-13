#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'parsecron';
zci is_cached => 0;

sub build_test {
    my ($answer, $input) = @_;
    return test_zci($answer, structured_answer => {
		data => {
			title => $answer,
			subtitle => "Crontab: $input"
		},
		templates => {
			group => 'text'
		}
	});
}

ddg_goodie_test(
	[qw(
		DDG::Goodie::ParseCron
	)],
    # Time
    'cron * * * * *' => build_test('every minute', '* * * * *'),
    'cron 5 0 * * *' => build_test('at 12:05am every day', '5 0 * * *'),
    'cron 0 */2 * * *' => build_test('every other hour', '0 */2 * * *'),
    'cron 0 0-23/2 * * *' => build_test('every other hour from 12am to 11pm', '0 0-23/2 * * *'),
    'cron 15 0-23/2,10,14 * * *' => build_test('15 minutes after every other hour from 12am to 11pm, 10am, and 2pm every day', '15 0-23/2,10,14 * * *'),
    'cron 0,15,30,45 4 * * *' => build_test('at 4:00am, 4:15am, 4:30am, and 4:45am every day', '0,15,30,45 4 * * *'), # exact times are returned
    'cron 45,15,30,15,0 4 * * *' => build_test('at 4:00am, 4:15am, 4:30am, and 4:45am every day', '45,15,30,15,0 4 * * *'),
    'cron 0,15,30,45 4,6,7,8 * * *' => build_test('0, 15, 30, and 45 minutes after 4am, 6am, 7am, and 8am every day', '0,15,30,45 4,6,7,8 * * *'), # too many exact times
    'cron 45,15,30,15,0 4,6,7,8 * * *' => build_test('45, 15, 30, 15, and 0 minutes after 4am, 6am, 7am, and 8am every day', '45,15,30,15,0 4,6,7,8 * * *'),
    'cron 5 1,4,6-7 * * *' => build_test('at 1:05am, 4:05am, 6:05am, and 7:05am every day', '5 1,4,6-7 * * *'),
    'cron 5 13,5 * * *' => build_test('at 5:05am and 1:05pm every day', '5 13,5 * * *'),
    'cron 1-9/2 * * * *' => build_test('every other minute from 1 to 9 minutes after every hour', '1-9/2 * * * *'),
    'cron */5 4 * * *' => build_test('every 5 minutes of 4am', '*/5 4 * * *'),
    'cron */5 * * * *' => build_test('every 5 minutes', '*/5 * * * *'),
    'crontab * */3 * * *' => build_test('every minute of every 3 hours', '* */3 * * *'),
    
    # Dates
    'cron 0 9 */3 * *' => build_test('at 9:00am every 3 days', '0 9 */3 * *'),
    'cron 0 9 */1 * *' => build_test('at 9:00am every day', '0 9 */1 * *'),
    'cron 0 9 1-15/2 * *' => build_test('at 9:00am every other day from 1st to 15th of every month', '0 9 1-15/2 * *'),
    'cron 0 9 * 6-8 *' => build_test('at 9:00am every day of June through August', '0 9 * 6-8 *'),
    'cron 0 9 */5 6-8 *' => build_test('at 9:00am every 5 days of June through August', '0 9 */5 6-8 *'),
    'cron 0 12 * */2 *' => build_test('at 12:00pm every day of every other month', '0 12 * */2 *'),
    'cron 0 12 * * */2' => build_test('at 12:00pm every other day of the week', '0 12 * * */2'),
    'cron 0 0 23 * *' => build_test('at midnight on the 23rd of every month', '0 0 23 * *'),# test ordinal suffixes
    'cron 0 0 13 * *' => build_test('at midnight on the 13th of every month', '0 0 13 * *'),
    'cron 0 0 22 * *' => build_test('at midnight on the 22nd of every month', '0 0 22 * *'),
    'cron 0 0 21 * *' => build_test('at midnight on the 21st of every month', '0 0 21 * *'),
    'cron 0 0 20 * *' => build_test('at midnight on the 20th of every month', '0 0 20 * *'),
    'cron 0 0 1,14 1-11 *' => build_test('at midnight on the 1st and 14th of January through November', '0 0 1,14 1-11 *'),
    'cron 0 0 * * 1-5' => build_test('at midnight Monday through Friday', '0 0 * * 1-5'),
    'cron 0 0 * 12 1-5' => build_test('at midnight Monday through Friday in December', '0 0 * 12 1-5'),
    'cron 0 0 23 * 1-5' => build_test('at midnight on the 23rd and Monday through Friday', '0 0 23 * 1-5'),
    'cron 0 0 23 1 1-5' => build_test('at midnight on the 23rd and Monday through Friday in January', '0 0 23 1 1-5'),
    'cron 0 0 * * 1-5' => build_test('at midnight Monday through Friday', '0 0 * * 1-5'),
    'cron 0 0 * * Sat-Sun' => build_test('at midnight Saturday through Sunday', '0 0 * * Sat-Sun'),
    'cron 0 0 * DEC,Jan-feb Sat-Sun' => build_test('at midnight Saturday through Sunday in December and January through February', '0 0 * DEC,Jan-feb Sat-Sun'),
    'cron 0 0 * * 0' => build_test('at midnight on Sunday', '0 0 * * 0'),
    'cron 0 0 * * 7' => build_test('at midnight on Sunday', '0 0 * * 7'),
    'cron 0/10 0/4 * * 0' => build_test('0, 10, 20, 30, 40, and 50 minutes after 12am, 4am, 8am, 12pm, 4pm, and 8pm on Sunday', '0/10 0/4 * * 0'),
    'cron 0/10 0/4 1/3 1/2 0/2' => build_test('0, 10, 20, 30, 40, and 50 minutes after 12am, 4am, 8am, 12pm, 4pm, and 8pm on the 1st, 4th, 7th, 10th, 13th, 16th, 19th, 22nd, 25th, 28th, and 31st and on Sunday, Tuesday, Thursday, and Saturday in January, March, May, July, September, and November', '0/10 0/4 1/3 1/2 0/2'),
    'cron * * * * 3/2' => build_test('every minute on Wednesday and Friday', '* * * * 3/2'),
    
    # Syntax errors
    'cron 0 0 * *' => undef,
    'cron 0 0 *' => undef,
    'cron 0 0' => undef,
    'cron 0' => undef,
    'cron ' => undef,
    'cron help' => undef,
    'cron cheatsheet' => undef,
    'crontab examples' => undef,
    'cron 0/10 0/4 0/3 1/2 0/2' => undef,
    'cron 0/10 0/4 1/3 0/2 0/2' => undef,
    
    # Complex examples
    'crontab 42 12 3 Feb Sat' => build_test('at 12:42pm on the 3rd and on Saturday in February', '42 12 3 Feb Sat'),
);

done_testing;
