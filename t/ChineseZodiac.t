#!/usr/bin/env perl

use strict;
use warnings;
use Test::MockTime qw( :all );
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'chinesezodiac';
zci is_cached   => 0;

my %animal_to_language_or_image = (
    'hare' => { en => 'Rabbit', zh => '兔', img => 'https://upload.wikimedia.org/wikipedia/commons/2/24/Rabbit.svg' },
    'dragon' => { en => 'Dragon', zh => '龙', img => 'https://upload.wikimedia.org/wikipedia/commons/b/b2/Dragon.svg' },
    'snake' => { en => 'Snake', zh => '蛇', img => 'https://upload.wikimedia.org/wikipedia/commons/1/1d/Snake.svg' },
    'horse' => { en => 'Horse', zh => '马', img => 'https://upload.wikimedia.org/wikipedia/commons/7/76/Horse.svg' },
    'sheep' => { en => 'Goat', zh => '羊', img => 'https://upload.wikimedia.org/wikipedia/commons/2/2d/Goat.svg' },
    'monkey' => { en => 'Monkey', zh => '猴', img => 'https://upload.wikimedia.org/wikipedia/commons/9/96/Monkey_2.svg' },
    'fowl' => { en => 'Rooster', zh => '鸡', img => 'https://upload.wikimedia.org/wikipedia/commons/0/06/Rooster.svg' },
    'dog' => { en => 'Dog', zh => '狗', img => 'https://upload.wikimedia.org/wikipedia/commons/4/4a/Dog_2.svg' },
    'pig' => { en => 'Pig', zh => '猪', img => 'https://upload.wikimedia.org/wikipedia/commons/d/d7/Boar.svg' },
    'rat' => { en => 'Rat', zh => '鼠', img => 'https://upload.wikimedia.org/wikipedia/commons/0/04/Rat.svg' },
    'ox' => { en => 'Ox', zh => '牛', img => 'https://upload.wikimedia.org/wikipedia/commons/d/d1/Oxen.svg' },
    'tiger' => { en => 'Tiger', zh => '虎', img => 'https://upload.wikimedia.org/wikipedia/commons/e/e3/Tiger.svg' }
);

sub build_answer {
    my ($animal, $statement) = @_;
    
    my $character = $animal_to_language_or_image{$animal}{'zh'};
    my $english = $animal_to_language_or_image{$animal}{'en'};
    my $img = $animal_to_language_or_image{$animal}{'img'};

    return test_zci("$character ($english)", structured_answer => {
        id => "chinese_zodiac",
        name => "Answer",
        data => {
            title => "$character ($english)",
            subtitle => $statement,
            url => "https://en.wikipedia.org/wiki/".$english."_(zodiac)",
            image => $img
        },
        templates => {
            group => "icon",
            item => 0,
            moreAt => 1,
            variants => {
                iconTitle => 'large',
                iconImage => 'large'
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
  'chinese zodiac for 1969' => build_answer('fowl', 'Chinese zodiac animal for 17 Feb 1969 – 05 Feb 1970'),

  #Secondary examples
  '2004 chinese zodiac animal' => build_answer('monkey', 'Chinese zodiac animal for 22 Jan 2004 – 08 Feb 2005'),
  'what was the chinese zodiac animal in 1992' => build_answer('monkey', 'Chinese zodiac animal for 04 Feb 1992 – 22 Jan 1993'),
  'what will the chinese zodiac animal be for 2056' => build_answer('rat', 'Chinese zodiac animal for 15 Feb 2056 – 03 Feb 2057'),
  
  #Primary example with different query formats
  '1969 chinese zodiac animal' => build_answer('fowl', 'Chinese zodiac animal for 17 Feb 1969 – 05 Feb 1970'),
  'what was the chinese zodiac animal for 1969' => build_answer('fowl', 'Chinese zodiac animal for 17 Feb 1969 – 05 Feb 1970'),
  'what will the chinese zodiac animal be for people born in the year 1969' => build_answer('fowl', 'Chinese zodiac animal for 17 Feb 1969 – 05 Feb 1970'),
  'chinese zodiac for a person born in 1969' => build_answer('fowl', 'Chinese zodiac animal for 17 Feb 1969 – 05 Feb 1970'),
  'chinese zodiac of 1969' => build_answer('fowl', 'Chinese zodiac animal for 17 Feb 1969 – 05 Feb 1970'),

  #Alternative triggers
  '1969 shēngxiào' => build_answer('fowl', 'Chinese zodiac animal for 17 Feb 1969 – 05 Feb 1970'),
  'shengxiao animal 1969' => build_answer('fowl', 'Chinese zodiac animal for 17 Feb 1969 – 05 Feb 1970'),
  'shēng xiào for 1969' => build_answer('fowl', 'Chinese zodiac animal for 17 Feb 1969 – 05 Feb 1970'),
  'i was born in 1969 what is my sheng xiao' => build_answer('fowl', 'Chinese zodiac animal for 17 Feb 1969 – 05 Feb 1970'),

  #Test some different years
  # Taken from http://www.chinesezodiac.com/calculator.php
  'chinese zodiac animal for 1924' => build_answer('rat', 'Chinese zodiac animal for 05 Feb 1924 – 23 Jan 1925'),
  'chinese zodiac animal for 1929' => build_answer('snake', 'Chinese zodiac animal for 10 Feb 1929 – 29 Jan 1930'),
  'chinese zodiac animal for 1934' => build_answer('dog', 'Chinese zodiac animal for 14 Feb 1934 – 03 Feb 1935'),
  'chinese zodiac animal for 1939' => build_answer('hare', 'Chinese zodiac animal for 19 Feb 1939 – 07 Feb 1940'),
  'chinese zodiac animal for 1944' => build_answer('monkey', 'Chinese zodiac animal for 25 Jan 1944 – 12 Feb 1945'),
  'chinese zodiac animal for 1949' => build_answer('ox', 'Chinese zodiac animal for 29 Jan 1949 – 16 Feb 1950'),
  'chinese zodiac animal for 1954' => build_answer('horse', 'Chinese zodiac animal for 03 Feb 1954 – 23 Jan 1955'),
  'chinese zodiac animal for 1959' => build_answer('pig', 'Chinese zodiac animal for 08 Feb 1959 – 27 Jan 1960'),
  'chinese zodiac animal for 1964' => build_answer('dragon', 'Chinese zodiac animal for 13 Feb 1964 – 01 Feb 1965'),
  'chinese zodiac animal for 1969' => build_answer('fowl', 'Chinese zodiac animal for 17 Feb 1969 – 05 Feb 1970'),
  'chinese zodiac animal for 1974' => build_answer('tiger', 'Chinese zodiac animal for 23 Jan 1974 – 10 Feb 1975'),
  'chinese zodiac animal for 2027' => build_answer('sheep', 'Chinese zodiac animal for 06 Feb 2027 – 25 Jan 2028'),
  'chinese zodiac animal for 2040' => build_answer('monkey', 'Chinese zodiac animal for 12 Feb 2040 – 31 Jan 2041'),

  #Test for correct date ranges
  # Taken from http://www.chinesezodiac.com/calculator.php
  'chinese zodiac animal for 1925' => build_answer('ox', 'Chinese zodiac animal for 24 Jan 1925 – 12 Feb 1926'),
  'chinese zodiac animal for 1937' => build_answer('ox', 'Chinese zodiac animal for 11 Feb 1937 – 30 Jan 1938'),
  'chinese zodiac animal for 1953' => build_answer('snake', 'Chinese zodiac animal for 14 Feb 1953 – 02 Feb 1954'),
  'chinese zodiac animal for 1973' => build_answer('ox', 'Chinese zodiac animal for 03 Feb 1973 – 22 Jan 1974'),
  'chinese zodiac animal for 1997' => build_answer('ox', 'Chinese zodiac animal for 07 Feb 1997 – 27 Jan 1998'),
  'chinese zodiac animal for 2013' => build_answer('snake', 'Chinese zodiac animal for 10 Feb 2013 – 30 Jan 2014'),
  'chinese zodiac animal for 2017' => build_answer('fowl', 'Chinese zodiac animal for 28 Jan 2017 – 15 Feb 2018'),
  'chinese zodiac animal for 2041' => build_answer('fowl', 'Chinese zodiac animal for 01 Feb 2041 – 21 Jan 2042'),

  #Handled by the date role–
  'chinese zodiac 20 march 1997' => build_answer('ox', 'Chinese zodiac animal for 07 Feb 1997 – 27 Jan 1998'),
  'chinese zodiac 1997-03-20' => build_answer('ox', 'Chinese zodiac animal for 07 Feb 1997 – 27 Jan 1998'),
  'what was the chinese zodiac animal on the 3rd of april 1945' => build_answer('fowl', 'Chinese zodiac animal for 13 Feb 1945 – 01 Feb 1946'),

  #Should not trigger
  'wikipedia chinese zodiac' => undef,
  'what is my zodiac sign' => undef,
  'what is the chinese word for duck' => undef,
  'buy an inflatable zodiac chinese online store' => undef,

  #No support currently for years outside 1900--2069
  'chinese zodiac 1899' => undef,
  'chinese zodiac 1900' => build_answer('rat', 'Chinese zodiac animal for 31 Jan 1900 – 18 Feb 1901'),
  'chinese zodiac 2069' => build_answer('ox', 'Chinese zodiac animal for 23 Jan 2069 – 10 Feb 2070'),
  'chinese zodiac 2070' => undef,
  'chinese zodiac 2000000000000' => undef

);

set_fixed_time("2014-12-01T00:00:00");
ddg_goodie_test(
	[qw(
		DDG::Goodie::ChineseZodiac
	)],
    "last year's chinese zodiac" => build_answer('snake', 'Chinese zodiac animal for 10 Feb 2013 – 30 Jan 2014'),
    "last years chinese zodiac" => build_answer('snake', 'Chinese zodiac animal for 10 Feb 2013 – 30 Jan 2014')
);
restore_time();

done_testing;

