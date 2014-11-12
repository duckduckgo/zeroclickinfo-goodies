#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "name_days_w25";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::NameDays )],
    'name day mieszko' => test_zci(' 1 Jan'),
    'maria imieniny' => test_zci('23 Jan,  2 Feb, 11 Feb, 25 Mar, 14 Apr, 26 Apr, 28 Apr,  3 May, 24 May, 25 May, 29 May,  2 Jun, 13 Jun, 27 Jun,  2 Jul, 16 Jul, 17 Jul, 22 Jul, 29 Jul,  2 Aug,  4 Aug,  5 Aug, 15 Aug, 22 Aug, 26 Aug,  8 Sep, 12 Sep, 15 Sep, 24 Sep,  7 Oct, 11 Oct, 16 Nov, 21 Nov,  8 Dec, 10 Dec'),
    '3 June name day' => test_zci('Konstantyn Leszek Paula Tamara'),
    'Name Day Tamara' => test_zci(' 3 Jun'),
    'namedays dec 30' => test_zci('Dawid Eugeniusz Katarzyna Uniedrog'),
    'name day 1 Jan' => test_zci('Mieczysław Mieszko'),
    
    # Genetive case
    'imieniny marii' => test_zci('23 Jan,  2 Feb, 11 Feb, 25 Mar, 14 Apr, 26 Apr, 28 Apr,  3 May, 24 May, 25 May, 29 May,  2 Jun, 13 Jun, 27 Jun,  2 Jul, 16 Jul, 17 Jul, 22 Jul, 29 Jul,  2 Aug,  4 Aug,  5 Aug, 15 Aug, 22 Aug, 26 Aug,  8 Sep, 12 Sep, 15 Sep, 24 Sep,  7 Oct, 11 Oct, 16 Nov, 21 Nov,  8 Dec, 10 Dec'),
    'imieniny Tamary' => test_zci(' 3 Jun'),
    'imieniny 29 Feb' => test_zci('Dobronieg Roman'),
    'imieniny February 29th' => test_zci('Dobronieg Roman'),
    
    # US date format
    'name days 12/30' => test_zci('Dawid Eugeniusz Katarzyna Uniedrog'),
    'name days 2/29' => test_zci('Dobronieg Roman'),
    'name days 1 / 09' => test_zci('Antoni Borzymir Julian Julianna'),
    
    # Polish date formats
    'imieniny 30.12' => test_zci('Dawid Eugeniusz Katarzyna Uniedrog'),
    'imieniny 9.01' => test_zci('Antoni Borzymir Julian Julianna'),
    'imieniny 09.01' => test_zci('Antoni Borzymir Julian Julianna'),
    'imieniny 9.1' => test_zci('Antoni Borzymir Julian Julianna'),
    'imieniny 9 stycznia' => test_zci('Antoni Borzymir Julian Julianna'),
    'imieniny 9 styczeń' => test_zci('Antoni Borzymir Julian Julianna'),
    'imieniny 31 Grudnia' => test_zci('Korneliusz Melania Sebastian Sylwester Tworzysław'),
    'Imieniny 31 GRUDNIA' => test_zci('Korneliusz Melania Sebastian Sylwester Tworzysław'),
    
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'name day 12/32' => undef,
    'name day 13/1' => undef,
    'name day 2/30' => undef,
    'name day 30.2' => undef,
    'name day 1.13' => undef,
    'name day 32.13' => undef,
    'imieniny w styczniu' => undef,
    'my name day' => undef,
    'name day in Poland' => undef,
    'name day' => undef,
);

done_testing;
