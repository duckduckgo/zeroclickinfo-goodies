#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Locale::Country;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "name_days";
zci is_cached   => 1;

# HTML formatting

sub get_flag {
    my $country = shift;
    return '<span class="flag-sm flag-sm-' . country2code($country) . '"></span>';
}

sub header_name {
    my $query = shift;
    return '<div class="zci--name_days"><span>Name days for <b>' . $query . '</b></span><div class="zci__content"><table>';
}

sub header_date {
    my $query = shift;
    return '<div class="zci--name_days"><span>Name days on <b>' . $query . '</b></span><div class="zci__content"><table>';
}

sub line {
    my ($country, $result) = @_;
    return '<tr><td class="name-days-country">' . get_flag($country) .
        ' <span class="name-days-country-name">' . $country . '</span>' .
        '</td><td class="name-days-dates">' . $result . '</td></tr>';
}

sub tile {
    my ($days, $month) = @_;
    return "<div class=\"name-days-tile\"><span>$month $days</span></div>";
}

my $footer = '</table></div></div>';



my $jan_9 = 'Croatia: Julijan, Živko, Miodrag; Czech Republic: Vladan; Denmark: Julianus; France: Alix; Greece: Martyr Polyeuctos; Hungary: Marcell; Latvia: Kaspars, Jautris; Poland: Antoni, Borzymir, Julian, Julianna; Slovakia: Alex, Alexej, Domoľub, Julián, Pravoľub, Vladan, Vladen, Alexia, Pravoľuba, Vladana, Vladena; Sweden: Gunnar, Gunder';
my $feb_29 = 'Czech Republic: Horymír; Denmark: Øllegaard; Poland: Dobronieg, Roman; Slovakia: Radomír, Radomíra';
my $dec_30 = 'Croatia: Silvestar, Silvestrovo, Zahvalnica; Czech Republic: David; Denmark: David; France: Roger; Hungary: Dávid; Latvia: Dāvis, Dāvids; Poland: Dawid, Eugeniusz, Katarzyna, Uniedrog; Slovakia: Dávid, Lotar; Sweden: Abel, Set';
my $dec_31 = 'Czech Republic: Silvestr; Denmark: Sylvester; France: Sylvestre; Hungary: Szilveszter; Latvia: Kalvis, Silvestris; ' .
             'Poland: Korneliusz, Melania, Sebastian, Sylwester, Tworzysław; Slovakia: Silvester, Horst; Sweden: Sylvester';
my $tamara = 'Czech Republic:  3 Jun; Hungary: 29 Dec; Poland:  3 Jun; Slovakia: 26 Jan';
my $marii = 'Poland: 23 Jan,  2 Feb, 11 Feb, 25 Mar, 14 Apr, 26 Apr, 28 Apr,  3 May, 24 May, 25 May, 29 May,  ' .
            '2 Jun, 13 Jun, 27 Jun,  2 Jul, 16 Jul, 17 Jul, 22 Jul, 29 Jul,  2 Aug,  4 Aug,  5 Aug, 15 Aug, 22 Aug, ' .
            '26 Aug,  8 Sep, 12 Sep, 15 Sep, 24 Sep,  7 Oct, 11 Oct, 16 Nov, 21 Nov,  8 Dec, 10 Dec';
my $maria = 'Bulgaria: 15 Aug; Denmark: 22 Jul, 15 Aug, 21 Nov; Greece: 22 Jul, 15 Aug, 21 Nov; ' .
            $marii . '; Sweden: 28 Feb';

my $jan_9_html = header_date('January 9th') . line('Croatia', 'Julijan, Živko, Miodrag') . line('Czech Republic', 'Vladan') .
                 line('Denmark', 'Julianus') . line('France', 'Alix') . line('Greece', 'Martyr Polyeuctos') . line('Hungary', 'Marcell') .
                 line('Latvia', 'Kaspars, Jautris') . line('Poland', 'Antoni, Borzymir, Julian, Julianna') .
                 line('Slovakia', 'Alex, Alexej, Domoľub, Julián, Pravoľub, Vladan, Vladen, Alexia, Pravoľuba, Vladana, Vladena') .
                 line('Sweden', 'Gunnar, Gunder') . $footer;

my $feb_29_html = header_date('February 29th') . line('Czech Republic', 'Horymír') . line('Denmark', 'Øllegaard') .
                  line('Poland', 'Dobronieg, Roman') . line('Slovakia', 'Radomír, Radomíra') . $footer;

my $dec_30_html = header_date('December 30th') . line('Croatia', 'Silvestar, Silvestrovo, Zahvalnica') . line('Czech Republic', 'David') .
                  line('Denmark', 'David') . line('France', 'Roger') . line('Hungary', 'Dávid'). line('Latvia', 'Dāvis, Dāvids').
                  line('Poland', 'Dawid, Eugeniusz, Katarzyna, Uniedrog') . line('Slovakia', 'Dávid, Lotar').
                  line('Sweden', 'Abel, Set'). $footer;

my $dec_31_html = header_date('December 31st') . line('Czech Republic', 'Silvestr') . line('Denmark', 'Sylvester') .
                  line('France', 'Sylvestre') . line('Hungary', 'Szilveszter') . line('Latvia', 'Kalvis, Silvestris') .
                  line('Poland', 'Korneliusz, Melania, Sebastian, Sylwester, Tworzysław') .
                  line('Slovakia', 'Silvester, Horst') . line('Sweden', 'Sylvester') . $footer;

my $tamara_html = header_name('Tamara') . line('Czech Republic', tile('3', 'Jun')) . line('Hungary', tile('29', 'Dec')) .
                  line('Poland', tile('3', 'Jun')) . line('Slovakia', tile('26', 'Jan')) . $footer;

my $maria_poland = line('Poland', tile('23', 'Jan') . tile('2, 11', 'Feb') . tile('25', 'Mar') . tile('14, 26, 28', 'Apr') .
                        tile('3, 24, 25, 29', 'May') . tile('2, 13, 27', 'Jun') . tile('2, 16, 17, 22, 29', 'Jul') .
                        tile('2, 4, 5, 15, 22, 26', 'Aug') . tile('8, 12, 15, 24', 'Sep') .
                        tile('7, 11', 'Oct') . tile('16, 21', 'Nov') . tile('8, 10', 'Dec'));
my $marii_html =  header_name('Marii') . $maria_poland . $footer;
my $maria_html =  header_name('Maria') . line('Bulgaria', tile('15', 'Aug')) .
                         line('Denmark', tile('22', 'Jul') . tile('15', 'Aug') . tile('21', 'Nov')) .
                         line('Greece', tile('22', 'Jul') . tile('15', 'Aug') . tile('21', 'Nov')) .
                         $maria_poland . line('Sweden', tile('28', 'Feb')) . $footer;


ddg_goodie_test(
    [qw( DDG::Goodie::NameDays )],
    'name day mieszko' => test_zci('Poland:  1 Jan', html =>
      header_name('Mieszko') . line('Poland', tile('1', 'Jan')) . $footer),
    'maria imieniny' => test_zci($maria, html => $maria_html),
    '3 June name day' => test_zci('Croatia: Karlo Lwanga, dr.; Czech Republic: Tamara; Denmark: Erasmus; France: Kévin; ' .
                    'Greece: Marinos, Nikiforos; Hungary: Klotild, Cecília; Latvia: Inta, Dailis; ' .
                    'Poland: Konstantyn, Leszek, Paula, Tamara; Slovakia: Karolína, Kevin, Lino, Linus, Palmíro, '.
                    'Kaja, Klotilda, Lina, Lineta, Palmíra; Sweden: Ingemar, Gudmar',
                          html => header_date('June 3rd') . line('Croatia', 'Karlo Lwanga, dr.') .line('Czech Republic', 'Tamara') .
                          line('Denmark', 'Erasmus') . line('France', 'Kévin') .
                          line('Greece', 'Marinos, Nikiforos') . line('Hungary', 'Klotild, Cecília') .
                          line('Latvia', 'Inta, Dailis') . line('Poland', 'Konstantyn, Leszek, Paula, Tamara') .
                          line('Slovakia', 'Karolína, Kevin, Lino, Linus, Palmíro, Kaja, Klotilda, Lina, Lineta, Palmíra') .
                          line('Sweden', 'Ingemar, Gudmar') . $footer),
    'Name Day Tamara' => test_zci($tamara, html => $tamara_html),
    'namedays dec 30' => test_zci($dec_30, html => $dec_30_html),
    'name day 1 Jan' => test_zci('Bulgaria: Vassil; Croatia: Marija; Denmark: Nytårsdag; France: Jour de l\'An; ' .
        'Greece: Basilius, Telemachus; Hungary: Fruzsina; Latvia: Solvija, Laimnesis; Poland: Mieczysław, Mieszko; Sweden: Nyårsdagen', html =>
      header_date('January 1st') . line('Bulgaria', 'Vassil') . line('Croatia', 'Marija') . line('Denmark', 'Nytårsdag') .
        line('France', 'Jour de l\'An') . line('Greece', 'Basilius, Telemachus') . line('Hungary', 'Fruzsina') .
        line('Latvia', 'Solvija, Laimnesis') . line('Poland', 'Mieczysław, Mieszko') . line('Sweden', 'Nyårsdagen') . $footer),
    'Radmila svátek' => test_zci('Croatia: 11 Apr; Czech Republic:  3 Jan; Slovakia:  3 Jan', html =>
      header_name('Radmila') . line('Croatia', tile('11', 'Apr')) . line('Czech Republic', tile('3', 'Jan')) .
        line('Slovakia', tile('3', 'Jan')) . $footer),

    # 1st, 2nd, 3rd, etc.
    'imieniny Dec 22' => test_zci('Croatia: Ivan Kentijski, Viktorija; Czech Republic: Šimon; Denmark: Japetus; France: François Xavière; ' .
                                  'Greece: Anastasias, Anastasia; Hungary: Zénó; Latvia: Donis, Donalds; ' .
                                  'Poland: Beata, Drogomir, Franciszka, Zenon; Slovakia: Adela, Ada, Adelaida, Adelgunda, Adelína, Adina, Alida; ' .
                                  'Sweden: Natanael, Jonatan', html =>
                                header_date('December 22nd') . line('Croatia', 'Ivan Kentijski, Viktorija') .
                                line('Czech Republic', 'Šimon') . line('Denmark', 'Japetus') . line('France', 'François Xavière') .
                                line('Greece', 'Anastasias, Anastasia') . line('Hungary', 'Zénó') . line('Latvia', 'Donis, Donalds') .
                                line('Poland', 'Beata, Drogomir, Franciszka, Zenon') .
                                line('Slovakia', 'Adela, Ada, Adelaida, Adelgunda, Adelína, Adina, Alida') .
                                line('Sweden', 'Natanael, Jonatan') . $footer ),

    'imieniny Aug 12' => test_zci('Croatia: Anicet, Hilarija; Czech Republic: Klára; Denmark: Clara; France: Clarisse; Hungary: Klára; ' .
                                  'Latvia: Klāra, Vārpa; Poland: Klara, Lech, Piotr; Slovakia: Darina, Dárius, Dária; Sweden: Klara', html =>
                                header_date('August 12th') . line('Croatia', 'Anicet, Hilarija') .
                                line('Czech Republic', 'Klára') . line('Denmark', 'Clara') . line('France', 'Clarisse') .
                                line('Hungary', 'Klára') . line('Latvia', 'Klāra, Vārpa') . line('Poland', 'Klara, Lech, Piotr') .
                                line('Slovakia', 'Darina, Dárius, Dária') . line('Sweden', 'Klara') . $footer ),

    # Genetive case
    'imieniny marii' => test_zci($marii, html => $marii_html),
    'imieniny Tamary' => test_zci("Poland:  3 Jun", html => header_name('Tamary') . line('Poland', tile('3', 'Jun')) . $footer),
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
