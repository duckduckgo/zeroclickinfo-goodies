#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "name_days_w25";
zci is_cached   => 1;

my $jan_9 = "Czech Republic: Vladan\nHungary: Marcell\nPoland: Antoni Borzymir Julian Julianna";
my $feb_29 = "Czech Republic: Horymír\nPoland: Dobronieg Roman";
my $dec_30 = "Czech Republic: David\nHungary: Dávid\nPoland: Dawid Eugeniusz Katarzyna Uniedrog";
my $dec_31 = "Czech Republic: Silvestr\nHungary: Szilveszter\nPoland: Korneliusz Melania Sebastian Sylwester Tworzysław";
my $tamara = "Czech Republic:  3 Jun\nHungary: 29 Dec\nPoland:  3 Jun";
my $marii = 'Poland: 23 Jan,  2 Feb, 11 Feb, 25 Mar, 14 Apr, 26 Apr, 28 Apr,  3 May, 24 May, 25 May, 29 May,  2 Jun, 13 Jun, 27 Jun,  2 Jul, 16 Jul, 17 Jul, 22 Jul, 29 Jul,  2 Aug,  4 Aug,  5 Aug, 15 Aug, 22 Aug, 26 Aug,  8 Sep, 12 Sep, 15 Sep, 24 Sep,  7 Oct, 11 Oct, 16 Nov, 21 Nov,  8 Dec, 10 Dec';

ddg_goodie_test(
    [qw( DDG::Goodie::NameDays )],
    'name day mieszko' => test_zci('Poland:  1 Jan'),
    'maria imieniny' => test_zci($marii),
    '3 June name day' => test_zci("Czech Republic: Tamara\nHungary: Klotild Cecília\nPoland: Konstantyn Leszek Paula Tamara"),
    'Name Day Tamara' => test_zci($tamara),
    'namedays dec 30' => test_zci($dec_30),
    'name day 1 Jan' => test_zci("Hungary: Fruzsina\nPoland: Mieczysław Mieszko"),
    
    # Genetive case
    'imieniny marii' => test_zci($marii),
    'imieniny Tamary' => test_zci("Poland:  3 Jun"),
    'imieniny Tamara' => test_zci($tamara),
    'imieniny 29 Feb' => test_zci($feb_29),
    'imieniny February 29th' => test_zci($feb_29),
    
    # US date format
    'name days 12/30' => test_zci($dec_30),
    'name days 2/29' => test_zci($feb_29),
    'name days 1 / 09' => test_zci($jan_9),
    
    # Polish date formats
    'imieniny 30.12' => test_zci($dec_30),
    'imieniny 9.01' => test_zci($jan_9),
    'imieniny 09.01' => test_zci($jan_9),
    'imieniny 9.1' => test_zci($jan_9),
    'imieniny 9 stycznia' => test_zci($jan_9),
    'imieniny 9 styczeń' => test_zci($jan_9),
    'imieniny 31 Grudnia' => test_zci($dec_31),
    'Imieniny 31 GRUDNIA' => test_zci($dec_31),
    'Imieniny 29 lutego' => test_zci($feb_29),
    
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
