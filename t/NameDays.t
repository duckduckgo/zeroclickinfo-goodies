#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "name_days_w25";
zci is_cached   => 1;

my $jan_9 = "Czech Republic: Vladan; Hungary: Marcell; Poland: Antoni, Borzymir, Julian, Julianna";
my $feb_29 = "Czech Republic: Horymír; Poland: Dobronieg, Roman";
my $dec_30 = "Czech Republic: David; Hungary: Dávid; Poland: Dawid, Eugeniusz, Katarzyna, Uniedrog";
my $dec_31 = "Czech Republic: Silvestr; Hungary: Szilveszter; Poland: Korneliusz, Melania, Sebastian, Sylwester, Tworzysław";
my $tamara = "Czech Republic:  3 Jun; Hungary: 29 Dec; Poland:  3 Jun";
my $marii = 'Poland: 23 Jan,  2 Feb, 11 Feb, 25 Mar, 14 Apr, 26 Apr, 28 Apr,  3 May, 24 May, 25 May, 29 May,  2 Jun, 13 Jun, 27 Jun,  2 Jul, 16 Jul, 17 Jul, 22 Jul, 29 Jul,  2 Aug,  4 Aug,  5 Aug, 15 Aug, 22 Aug, 26 Aug,  8 Sep, 12 Sep, 15 Sep, 24 Sep,  7 Oct, 11 Oct, 16 Nov, 21 Nov,  8 Dec, 10 Dec';

my $jan_9_html = "<b>Czech Republic:</b> Vladan; <b>Hungary:</b> Marcell; <b>Poland:</b> Antoni, Borzymir, Julian, Julianna";
my $feb_29_html = "<b>Czech Republic:</b> Horymír; <b>Poland:</b> Dobronieg, Roman";
my $dec_30_html = "<b>Czech Republic:</b> David; <b>Hungary:</b> Dávid; <b>Poland:</b> Dawid, Eugeniusz, Katarzyna, Uniedrog";
my $dec_31_html = "<b>Czech Republic:</b> Silvestr; <b>Hungary:</b> Szilveszter; <b>Poland:</b> Korneliusz, Melania, Sebastian, Sylwester, Tworzysław";
my $tamara_html = "<b>Czech Republic:</b>  3 Jun; <b>Hungary:</b> 29 Dec; <b>Poland:</b>  3 Jun";
my $marii_html = '<b>Poland:</b> 23 Jan,  2 Feb, 11 Feb, 25 Mar, 14 Apr, 26 Apr, 28 Apr,  3 May, 24 May, 25 May, 29 May,  2 Jun, 13 Jun, 27 Jun,  2 Jul, 16 Jul, 17 Jul, 22 Jul, 29 Jul,  2 Aug,  4 Aug,  5 Aug, 15 Aug, 22 Aug, 26 Aug,  8 Sep, 12 Sep, 15 Sep, 24 Sep,  7 Oct, 11 Oct, 16 Nov, 21 Nov,  8 Dec, 10 Dec';


ddg_goodie_test(
    [qw( DDG::Goodie::NameDays )],
    'name day mieszko' => test_zci('Poland:  1 Jan', html => '<b>Poland:</b>  1 Jan'),
    'maria imieniny' => test_zci($marii, html => $marii_html),
    '3 June name day' => test_zci("Czech Republic: Tamara; Hungary: Klotild, Cecília; Poland: Konstantyn, Leszek, Paula, Tamara",
                          html => "<b>Czech Republic:</b> Tamara; <b>Hungary:</b> Klotild, Cecília; <b>Poland:</b> Konstantyn, Leszek, Paula, Tamara"),
    'Name Day Tamara' => test_zci($tamara, html => $tamara_html),
    'namedays dec 30' => test_zci($dec_30, html => $dec_30_html),
    'name day 1 Jan' => test_zci("Hungary: Fruzsina; Poland: Mieczysław, Mieszko", html => "<b>Hungary:</b> Fruzsina; <b>Poland:</b> Mieczysław, Mieszko"),
    'Radmila svátek' => test_zci('Czech Republic:  3 Jan', html => '<b>Czech Republic:</b>  3 Jan'),
    
    # Genetive case
    'imieniny marii' => test_zci($marii, html => $marii_html),
    'imieniny Tamary' => test_zci("Poland:  3 Jun", html => "<b>Poland:</b>  3 Jun"),
    'imieniny Tamara' => test_zci($tamara, html => $tamara_html),
    'imieniny 29 Feb' => test_zci($feb_29, html => $feb_29_html),
    'imieniny February 29th' => test_zci($feb_29, html => $feb_29_html),
    
    # US date format
    'name days 12/30' => test_zci($dec_30, html => $dec_30_html),
    'name days 2/29' => test_zci($feb_29, html => $feb_29_html),
    'name days 1 / 09' => test_zci($jan_9, html => $jan_9_html),
    
    # Polish date formats
    'imieniny 30.12' => test_zci($dec_30, html => $dec_30_html),
    'imieniny 9.01' => test_zci($jan_9, html => $jan_9_html),
    'imieniny 09.01' => test_zci($jan_9, html => $jan_9_html),
    'imieniny 9.1' => test_zci($jan_9, html => $jan_9_html),
    'imieniny 9 stycznia' => test_zci($jan_9, html => $jan_9_html),
    'imieniny 9 styczeń' => test_zci($jan_9, html => $jan_9_html),
    'imieniny 31 Grudnia' => test_zci($dec_31, html => $dec_31_html),
    'Imieniny 31 GRUDNIA' => test_zci($dec_31, html => $dec_31_html),
    'Imieniny 29 lutego' => test_zci($feb_29, html => $feb_29_html),
    
    # Czech date formats
    'svátek 9 ledna' => test_zci($jan_9, html => $jan_9_html),
    'jmeniny 9 leden' => test_zci($jan_9, html => $jan_9_html),
    'svátek 31 Prosince' => test_zci($dec_31, html => $dec_31_html),
    'jmeniny 29 února' => test_zci($feb_29, html => $feb_29_html),
    
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
