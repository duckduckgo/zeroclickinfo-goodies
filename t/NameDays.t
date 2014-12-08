#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "name_days_w25";
zci is_cached   => 1;

# HTML formatting

sub header {
    my $query = shift();
    return '<div class="zci__body"><span class="zci__header">' . $query . '</span>' .
           '<span class="zci__subheader">Name days</span><div class="zci__content"><table>';
}

sub line {
    my ($country, $result) = @_;
    return '<tr><td class="name-days-country">' . $country . '</td><td>' . $result . '</td></tr>';
}

sub tile {
    my ($days, $month) = @_;
    return '<div class="name-days-tile"><div class="name-days-tile-body">' .
           '<h4>' . $days . '</h4><p>' . $month . '</p></div></div>';
}

my $footer = '</table></div></div>';



my $jan_9 = 'Czech Republic: Vladan; Hungary: Marcell; Poland: Antoni, Borzymir, Julian, Julianna';
my $feb_29 = 'Czech Republic: Horymír; Poland: Dobronieg, Roman';
my $dec_30 = 'Czech Republic: David; Hungary: Dávid; Poland: Dawid, Eugeniusz, Katarzyna, Uniedrog';
my $dec_31 = 'Czech Republic: Silvestr; Hungary: Szilveszter; Poland: Korneliusz, Melania, Sebastian, Sylwester, Tworzysław';
my $tamara = 'Czech Republic:  3 Jun; Hungary: 29 Dec; Poland:  3 Jun';
my $marii = 'Poland: 23 Jan,  2 Feb, 11 Feb, 25 Mar, 14 Apr, 26 Apr, 28 Apr,  3 May, 24 May, 25 May, 29 May,  ' .
            '2 Jun, 13 Jun, 27 Jun,  2 Jul, 16 Jul, 17 Jul, 22 Jul, 29 Jul,  2 Aug,  4 Aug,  5 Aug, 15 Aug, 22 Aug, ' .
            '26 Aug,  8 Sep, 12 Sep, 15 Sep, 24 Sep,  7 Oct, 11 Oct, 16 Nov, 21 Nov,  8 Dec, 10 Dec';

my $jan_9_html = header('January  9th') . line('Czech Republic', 'Vladan') . line('Hungary', 'Marcell') .
                 line('Poland', 'Antoni, Borzymir, Julian, Julianna') . $footer;

my $feb_29_html = header('February 29th') . line('Czech Republic', 'Horymír') .
                  line('Poland', 'Dobronieg, Roman') . $footer;

my $dec_30_html = header('December 30th') . line('Czech Republic', 'David') .
                  line('Hungary', 'Dávid'). line('Poland', 'Dawid, Eugeniusz, Katarzyna, Uniedrog') . $footer;

my $dec_31_html = header('December 31st') . line('Czech Republic', 'Silvestr') . line('Hungary', 'Szilveszter') .
                  line('Poland', 'Korneliusz, Melania, Sebastian, Sylwester, Tworzysław') . $footer;
                  
my $tamara_html = header('Tamara') . line('Czech Republic', tile('3', 'Jun')) . line('Hungary', tile('29', 'Dec')) .
                  line('Poland', tile('3', 'Jun')) . $footer;
my $marii_html =  line('Poland', tile('23', 'Jan') . tile('2, 11', 'Feb') . tile('25', 'Mar') . tile('14, 26, 28', 'Apr') .
                        tile('3, 24, 25, 29', 'May') . tile('2, 13, 27', 'Jun') . tile('2, 16, 17, 22, 29', 'Jul') .
                        tile('2, 4, 5, 15, 22, 26', 'Aug') . tile('8, 12, 15, 24', 'Sep') .
                        tile('7, 11', 'Oct') . tile('16, 21', 'Nov') . tile('8, 10', 'Dec')) . $footer;


ddg_goodie_test(
    [qw( DDG::Goodie::NameDays )],
    'name day mieszko' => test_zci('Poland:  1 Jan', html =>
    	header('Mieszko') . line('Poland', tile('1', 'Jan')) . $footer),
    'maria imieniny' => test_zci($marii, html => header('Maria') . $marii_html),
    '3 June name day' => test_zci('Czech Republic: Tamara; Hungary: Klotild, Cecília; Poland: Konstantyn, Leszek, Paula, Tamara',
                          html => header('June  3rd') . line('Czech Republic', 'Tamara') .
                          line('Hungary', 'Klotild, Cecília') . line('Poland', 'Konstantyn, Leszek, Paula, Tamara') . $footer),
    'Name Day Tamara' => test_zci($tamara, html => $tamara_html),
    'namedays dec 30' => test_zci($dec_30, html => $dec_30_html),
    'name day 1 Jan' => test_zci('Hungary: Fruzsina; Poland: Mieczysław, Mieszko', html =>
    	header('January  1st') . line('Hungary', 'Fruzsina') . line('Poland', 'Mieczysław, Mieszko') . $footer),
    'Radmila svátek' => test_zci('Czech Republic:  3 Jan', html =>
    	header('Radmila') . line('Czech Republic', tile('3', 'Jan')) . $footer),
    
    # Genetive case
    'imieniny marii' => test_zci($marii, html => header('Marii') . $marii_html),
    'imieniny Tamary' => test_zci("Poland:  3 Jun", html => header('Tamary') . line('Poland', tile('3', 'Jun')) . $footer),
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
