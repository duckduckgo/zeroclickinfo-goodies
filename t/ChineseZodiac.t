#!/usr/bin/env perl

use strict;
use warnings;
use Test::MockTime qw( :all );
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'chinesezodiac';
zci is_cached   => 0;

my $goodie_version = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

my %animal_attributes = (
    'hare' => { en => 'Rabbit', zh => '兔' , icon => "rabbit.png", class => "bg-clr--wood"},
    'dragon' => { en => 'Dragon', zh => '龙' , icon => "dragon.png", class => "bg-clr--green"},
    'snake' => { en => 'Snake', zh => '蛇' , icon => "snake.png", class => "bg-clr--red"},
    'horse' => { en => 'Horse', zh => '马' , icon => "horse.png", class => "bg-clr--red"},
    'sheep' => { en => 'Goat', zh => '羊' , icon => "goat.png", class => "bg-clr--green"},
    'monkey' => { en => 'Monkey', zh => '猴' , icon => "monkey.png", class => "bg-clr--grey"},
    'fowl' => { en => 'Rooster', zh => '鸡' , icon => "rooster.png", class => "bg-clr--grey"},
    'dog' => { en => 'Dog', zh => '狗' , icon => "dog.png", class => "bg-clr--green"},
    'pig' => { en => 'Pig', zh => '猪' , icon => "pig.png", class => "bg-clr--blue-light"},
    'rat' => { en => 'Rat', zh => '鼠' , icon => "rat.png", class => "bg-clr--blue-light"},
    'ox' => { en => 'Ox', zh => '牛' , icon => "ox.png", class => "bg-clr--green"},
    'tiger' => { en => 'Tiger', zh => '虎' , icon => "tiger.png", class => "bg-clr--wood"}
);

sub build_answer {
    my ($animal, $statement) = @_;
    
    my $character = $animal_attributes{$animal}{'zh'};
    my $english = $animal_attributes{$animal}{'en'};
    my $path = "/share/goodie/chinese_zodiac/$goodie_version/$animal_attributes{$animal}->{'icon'}";
    my $class = $animal_attributes{$animal}{'class'};

    return test_zci("$character ($english)", structured_answer => {
        data => {
            title => "$character ($english)",
            subtitle => $statement,
            image => $path,
            url => "https://en.wikipedia.org/wiki/$english\_(zodiac)"
        },
        templates => {
            group => "icon",
            item => 0,
            moreAt => 1,
            variants => {
                iconTitle => 'large',
                iconImage => 'large'
            },
            elClass => {
                iconImage => "$class circle"
            }
        },
        meta => {
            sourceName => "Wikipedia",
            sourceUrl => "https://en.wikipedia.org/wiki/Chinese_zodiac"
        }
    })
}

ddg_goodie_test(
	[qw(
		DDG::Goodie::ChineseZodiac
	)],

  #Primary example
  'chinese zodiac for 1969' => build_answer('fowl', 'Feb 17, 1969 – Feb 05, 1970'),

  #Secondary examples
  '2004 chinese zodiac animal' => build_answer('monkey', 'Jan 22, 2004 – Feb 08, 2005'),
  'what was the chinese zodiac animal in 1992' => build_answer('monkey', 'Feb 04, 1992 – Jan 22, 1993'),
  'what will the chinese zodiac animal be for 2056' => build_answer('rat', 'Feb 15, 2056 – Feb 03, 2057'),
  
  #Primary example with different query formats
  '1969 chinese zodiac animal' => build_answer('fowl', 'Feb 17, 1969 – Feb 05, 1970'),
  'what was the chinese zodiac animal for 1969' => build_answer('fowl', 'Feb 17, 1969 – Feb 05, 1970'),
  'what will the chinese zodiac animal be for people born in the year 1969' => build_answer('fowl', 'Feb 17, 1969 – Feb 05, 1970'),
  'chinese zodiac for a person born in 1969' => build_answer('fowl', 'Feb 17, 1969 – Feb 05, 1970'),
  'chinese zodiac of 1969' => build_answer('fowl', 'Feb 17, 1969 – Feb 05, 1970'),

  #Alternative triggers
  '1969 shēngxiào' => build_answer('fowl', 'Feb 17, 1969 – Feb 05, 1970'),
  'shengxiao animal 1969' => build_answer('fowl', 'Feb 17, 1969 – Feb 05, 1970'),
  'shēng xiào for 1969' => build_answer('fowl', 'Feb 17, 1969 – Feb 05, 1970'),
  'i was born in 1969 what is my sheng xiao' => build_answer('fowl', 'Feb 17, 1969 – Feb 05, 1970'),

  #Test some different years
  # Taken from http://www.chinesezodiac.com/calculator.php
  'chinese zodiac animal for 1924' => build_answer('rat', 'Feb 05, 1924 – Jan 23, 1925'),
  'chinese zodiac animal for 1929' => build_answer('snake', 'Feb 10, 1929 – Jan 29, 1930'),
  'chinese zodiac animal for 1934' => build_answer('dog', 'Feb 14, 1934 – Feb 03, 1935'),
  'chinese zodiac animal for 1939' => build_answer('hare', 'Feb 19, 1939 – Feb 07, 1940'),
  'chinese zodiac animal for 1944' => build_answer('monkey', 'Jan 25, 1944 – Feb 12, 1945'),
  'chinese zodiac animal for 1949' => build_answer('ox', 'Jan 29, 1949 – Feb 16, 1950'),
  'chinese zodiac animal for 1954' => build_answer('horse', 'Feb 03, 1954 – Jan 23, 1955'),
  'chinese zodiac animal for 1959' => build_answer('pig', 'Feb 08, 1959 – Jan 27, 1960'),
  'chinese zodiac animal for 1964' => build_answer('dragon', 'Feb 13, 1964 – Feb 01, 1965'),
  'chinese zodiac animal for 1969' => build_answer('fowl', 'Feb 17, 1969 – Feb 05, 1970'),
  'chinese zodiac animal for 1974' => build_answer('tiger', 'Jan 23, 1974 – Feb 10, 1975'),
  'chinese zodiac animal for 2027' => build_answer('sheep', 'Feb 06, 2027 – Jan 25, 2028'),
  'chinese zodiac animal for 2040' => build_answer('monkey', 'Feb 12, 2040 – Jan 31, 2041'),

  #Test for correct date ranges
  # Taken from http://www.chinesezodiac.com/calculator.php
  'chinese zodiac animal for 1925' => build_answer('ox', 'Jan 24, 1925 – Feb 12, 1926'),
  'chinese zodiac animal for 1937' => build_answer('ox', 'Feb 11, 1937 – Jan 30, 1938'),
  'chinese zodiac animal for 1953' => build_answer('snake', 'Feb 14, 1953 – Feb 02, 1954'),
  'chinese zodiac animal for 1973' => build_answer('ox', 'Feb 03, 1973 – Jan 22, 1974'),
  'chinese zodiac animal for 1997' => build_answer('ox', 'Feb 07, 1997 – Jan 27, 1998'),
  'chinese zodiac animal for 2013' => build_answer('snake', 'Feb 10, 2013 – Jan 30, 2014'),
  'chinese zodiac animal for 2017' => build_answer('fowl', 'Jan 28, 2017 – Feb 15, 2018'),
  'chinese zodiac animal for 2041' => build_answer('fowl', 'Feb 01, 2041 – Jan 21, 2042'),

  #Handled by the date role–
  'chinese zodiac 20 march 1997' => build_answer('ox', 'Feb 07, 1997 – Jan 27, 1998'),
  'chinese zodiac 1997-03-20' => build_answer('ox', 'Feb 07, 1997 – Jan 27, 1998'),
  'what was the chinese zodiac animal on the 3rd of april 1945' => build_answer('fowl', 'Feb 13, 1945 – Feb 01, 1946'),

  #Should not trigger
  'wikipedia chinese zodiac' => undef,
  'what is my zodiac sign' => undef,
  'what is the chinese word for duck' => undef,
  'buy an inflatable zodiac chinese online store' => undef,

  #No support currently for years outside 1900--2069
  'chinese zodiac 1899' => undef,
  'chinese zodiac 1900' => build_answer('rat', 'Jan 31, 1900 – Feb 18, 1901'),
  'chinese zodiac 2069' => build_answer('ox', 'Jan 23, 2069 – Feb 10, 2070'),
  'chinese zodiac 2070' => undef,
  'chinese zodiac 2000000000000' => undef

);

set_fixed_time("2014-12-01T00:00:00");
ddg_goodie_test(
	[qw(
		DDG::Goodie::ChineseZodiac
	)],
    "last year's chinese zodiac" => build_answer('snake', 'Feb 10, 2013 – Jan 30, 2014'),
    "last years chinese zodiac" => build_answer('snake', 'Feb 10, 2013 – Jan 30, 2014')
);
restore_time();

done_testing;
