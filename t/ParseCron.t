#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'parsecron';
zci is_cached   => 0;

ddg_goodie_test(
    ['DDG::Goodie::ParseCron'],    
    'crontab * * * * *'             => test_zci('(* * * * *) means this cron job will run: Every minute of every hour of every day',),
    'crontab * */3 * * *'           => test_zci('(* */3 * * *) means this cron job will run: Every minute of every third hour of every day',),
    'crontab 42 12 3 Feb Sat'       => test_zci('(42 12 3 Feb Sat) means this cron job will run: 12:42pm on the third of -- or every Saturday in -- February',),
    'crontab * * * * * prog.pl'     => undef
);

done_testing;
