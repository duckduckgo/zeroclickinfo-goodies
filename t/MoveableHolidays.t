#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test::More;
use Test::MockTime qw( :all );
use DDG::Test::Goodie;

zci answer_type => "moveable_holiday";
zci is_cached   => 0;

set_fixed_time("2013-01-01T10:00:00");

sub get_test {
    my ($text, $year, $operation) = @_;
    return test_zci($text, structured_answer => {
            input => [$year],
            operation => $operation,
            result => $text
        });
}

my $w_easter = 'Easter (Western Christianity)';
my $o_easter = 'Easter (Orthodox Christianity)';

ddg_goodie_test(
    [qw( DDG::Goodie::MoveableHolidays )],
    
    'Easter 2015' => get_test('5 April', '2015', $w_easter),
    'Easter date' => get_test('31 March', '2013', $w_easter),
    'date of easter' => get_test('31 March', '2013', $w_easter),
    'when is Easter' => get_test('31 March', '2013', $w_easter),
    'easter date 1995' => get_test('16 April', '1995', $w_easter),
    'EASTER 1995 date' => get_test('16 April', '1995', $w_easter),
    'easter 2014' => get_test('20 April', '2014', $w_easter),
    'date of easter 2014' => get_test('20 April', '2014', $w_easter),
    'Easter 2016' => get_test('27 March', '2016', $w_easter),
    
    'Orthodox Easter 2015' => get_test('12 April', '2015', $o_easter),
    'Orthodox Easter date' => get_test('5 May', '2013', $o_easter),
    'date of Orthodox easter' => get_test('5 May', '2013', $o_easter),
    'when is Orthodox Easter' => get_test('5 May', '2013', $o_easter),
    'Orthodox Easter date 1995' => get_test('23 April', '1995', $o_easter),
    'Orthodox Easter 1995 date' => get_test('23 April', '1995', $o_easter),
    'Orthodox easter 2014' => get_test('20 April', '2014', $o_easter),
    'date of Orthodox easter 2014' => get_test('20 April', '2014', $o_easter),
    'Orthodox Easter 2016' => get_test('1 May', '2016', $o_easter),
        
    'catholic easter 2016' => get_test('27 March', '2016', $w_easter),
    'protestant easter 2016' => get_test('27 March', '2016', $w_easter),
    'orthodox easter 2016' => get_test('1 May', '2016', $o_easter),
    'western easter 2016' => get_test('27 March', '2016', $w_easter),

    'easter 1900' => get_test('15 April', '1900', $w_easter),
    'date of easter 1951' => get_test('25 March', '1951', $w_easter),
    'when is easter 1850' => get_test('31 March', '1850', $w_easter),
    'when is easter 1800' => get_test('13 April', '1800', $w_easter),
    'when is easter 1803' => get_test('10 April', '1803', $w_easter),
    'easter 2299' => get_test('16 April', '2299', $w_easter),
    'easter 2298' => get_test('3 April', '2298', $w_easter),

    'orthodox easter 1900' => get_test('22 April', '1900', $o_easter),
    'date of eastern easter 1951' => get_test('29 April', '1951', $o_easter),
    'when is orthodox easter 1850' => get_test('5 May', '1850', $o_easter),
    'when is orthodox easter 1800' => get_test('20 April', '1800', $o_easter),
    'when is orthodox easter 1803' => get_test('17 April', '1803', $o_easter),
    'orthodox easter 2299' => get_test('23 April', '2299', $o_easter),
    'orthodox easter 2298' => get_test('8 May', '2298', $o_easter),
    
    'good friday 2015' => get_test('3 April', '2015', 'Good Friday (Western Christianity)'),
    'western good friday 2015' => get_test('3 April', '2015', 'Good Friday (Western Christianity)'),
    'orthodox good friday 2015' => get_test('10 April', '2015', 'Good Friday (Orthodox Christianity)'),
    
    'Ascension Day 2016' => get_test('5 May', '2016', 'Ascension Day (Western Christianity)'),
    'orthodox ascension 2016' => get_test('9 June', '2016', 'Ascension (Orthodox Christianity)'),
    'ascension thursday 2017' => get_test('25 May', '2017', 'Ascension Thursday (Western Christianity)'),
    
    'pentecost 2015' => get_test('24 May', '2015', 'Pentecost (Western Christianity)'),
    'western pentecost 2016' => get_test('15 May', '2016', 'Pentecost (Western Christianity)'),
    'orthodox pentecost 2016' => get_test('19 June', '2016', 'Pentecost (Orthodox Christianity)'),
    'orthodox Trinity Sunday 2016' => get_test('19 June', '2016', 'Trinity Sunday (Orthodox Christianity)'),
    
    'Trinity Sunday 2016' => get_test('22 May', '2016', 'Trinity Sunday (Western Christianity)'),
    'Corpus Christi 2015' => get_test('4 June', '2015', 'Corpus Christi (Western Christianity)'),
    'Orthodox Corpus Christi 2015' => get_test('4 June', '2015', 'Corpus Christi (Western Christianity)'), # cannot be Orthodox
    
    'Mardi Gras 2015' => get_test('17 February', '2015', 'Mardi Gras (Western Christianity)'),
    'Shrove Tuesday 2016' => get_test('9 February', '2016', 'Shrove Tuesday (Western Christianity)'),
    'Fat Tuesday 2015' => get_test('17 February', '2015', 'Fat Tuesday (Western Christianity)'),
    'Orthodox Mardi Gras 2015' => get_test('17 February', '2015', 'Mardi Gras (Western Christianity)'), # cannot be Orthodox
    
    'Ash Wednesday 2015' => get_test('18 February', '2015', 'Ash Wednesday (Western Christianity)'),
    'Orthodox Ash Wednesday 2015' => get_test('18 February', '2015', 'Ash Wednesday (Western Christianity)'), # cannot be Orthodox
    
    'Passover 2015' => get_test('4 April', '2015', 'Passover'),
    'Pesach 2015' => get_test('4 April', '2015', 'Pesach'),
    'Yom Kippur 2015' => get_test('23 September', '2015', 'Yom Kippur'),
    'Rosh Hashanah 2014' => get_test('25 September', '2014', 'Rosh Hashanah'),
    'rosh hashana 2015' => get_test('14 September', '2015', 'Rosh Hashana'),
    'Jewish Holidays 2014' => get_test('Purim: 16 March, Passover: 15 April, Shavuot: 4 June, ' .
        'Rosh Hashanah: 25 September, Yom Kippur: 4 October, Sukkot: 9 October, Hanukkah: 17 December',
        '2014', 'Jewish Holidays'),
    'Passover 2099' => get_test('5 April', '2099', 'Passover'),
    'Chanukkah 2015' => get_test('7 December', '2015', 'Chanukkah'),
    'Hanukkah 2013' => get_test('28 November', '2013', 'Hanukkah'),
    'Purim 2013' => get_test('24 February', '2013', 'Purim'),
    'Purim 2015' => get_test('5 March', '2015', 'Purim'),
    'Purim 2016' => get_test('24 March', '2016', 'Purim'),
    'Purim 2017' => get_test('12 March', '2017', 'Purim'),
    'jewish holidays 2007' => get_test('Purim: 4 March, Passover: 3 April, Shavuot: 23 May, ' .
        'Rosh Hashanah: 13 September, Yom Kippur: 22 September, Sukkot: 27 September, Hanukkah: 5 December',
        '2007', 'Jewish Holidays'),
        
    'jewish holidays 2008' => get_test('Purim: 21 March, Passover: 20 April, Shavuot: 9 June, ' .
        'Rosh Hashanah: 30 September, Yom Kippur: 9 October, Sukkot: 14 October, Hanukkah: 22 December',
        '2008', 'Jewish Holidays'), 
        
    'Jewish holidays 2009' => get_test('Purim: 10 March, Passover: 9 April, Shavuot: 29 May, ' .
        'Rosh Hashanah: 19 September, Yom Kippur: 28 September, Sukkot: 3 October, Hanukkah: 12 December',
        '2009', 'Jewish Holidays'),
        
    'Jewish holidays 2015' => get_test('Purim: 5 March, Passover: 4 April, Shavuot: 24 May, ' .
        'Rosh Hashanah: 14 September, Yom Kippur: 23 September, Sukkot: 28 September, Hanukkah: 7 December',
        '2015', 'Jewish Holidays'),
        
    'Jewish holidays 2016' => get_test('Purim: 24 March, Passover: 23 April, Shavuot: 12 June, ' .
        'Rosh Hashanah: 3 October, Yom Kippur: 12 October, Sukkot: 17 October, Hanukkah: 25 December',
        '2016', 'Jewish Holidays'),
    
    'Hebrew holidays 2017' => get_test('Purim: 12 March, Passover: 11 April, Shavuot: 31 May, ' .
        'Rosh Hashanah: 21 September, Yom Kippur: 30 September, Sukkot: 5 October, Hanukkah: 13 December',
        '2017', 'Hebrew Holidays'),
        
    'thanksgiving 2015' => get_test('United States: 26 November, Canada: 12 October', '2015', 'Thanksgiving'),
    'labor day 2015' => get_test('7 September', '2015', 'Labor Day (United States)'),
    'Columbus Day date' => get_test('14 October', '2013', 'Columbus Day (United States)'),
    '2015 Memorial Day' => get_test('25 May', '2015', 'Memorial Day (United States)'),
    '2015 Presidents\' Day' => get_test('16 February', '2015', 'Presidents\' Day (United States)'),
    'presidents day 2015' => get_test('16 February', '2015', 'Presidents Day (United States)'),
    'president\'s day date 2015' => get_test('16 February', '2015', 'President\'s Day (United States)'),
    'washington\'s birthday 2015' => get_test('16 February', '2015', 'Washington\'s Birthday (United States)'),
    'Martin Luther King Day 2015' => get_test('19 January', '2015', 'Martin Luther King Day (United States)'),

    'American Family Day 2015' => get_test('2 August', '2015', 'American Family Day (United States)'),
    'Casimir Pulaski Day 2015' => get_test('2 March', '2015', 'Casimir Pulaski Day (United States)'),
    'Pulaski Days 2015' => get_test('2 October', '2015', 'Pulaski Days (United States)'),
    'Child Health Day 2015' => get_test('5 October', '2015', 'Child Health Day (United States)'),
    'Fraternal Day 2015' => get_test('12 October', '2015', 'Fraternal Day (United States)'),
    'Hawaii Admission Day 2015' => get_test('21 August', '2015', 'Hawaii Admission Day (United States)'),
    'Indigenous Peoples\' Day 2015' => get_test('12 October', '2015', 'Indigenous Peoples\' Day (United States)'),
    'Missouri Day 2015' => get_test('21 October', '2015', 'Missouri Day (United States)'),
    'National Day of Prayer 2015' => get_test('7 May', '2015', 'National Day of Prayer (United States)'),
    'National Day of Reason 2015' => get_test('7 May', '2015', 'National Day of Reason (United States)'),
    'Nevada Day 2015' => get_test('30 October', '2015', 'Nevada Day (United States)'),
    'Patriots\' Day 2015' => get_test('20 April', '2015', 'Patriots\' Day (United States)'),
    'Pioneer Days 2015' => get_test('2 May', '2015', 'Pioneer Days (United States)'),
    'Sweetest Day 2015' => get_test('17 October', '2015', 'Sweetest Day (United States)'),

    '成人の日 2015' => get_test('12 January', '2015', '成人の日 (Japan)'), # https://en.wikipedia.org/wiki/Coming_of_Age_Day
    'coming of age day 2017' => get_test('9 January', '2017', 'Coming of Age Day (Japan)'),
    
    'Programmers\' Day 2015' => get_test('13 September', '2015', 'Programmers\' Day'),
    'Programmer Day 2016' => get_test('12 September', '2016', 'Programmer Day'),
    'Programmer\'s Day 2017' => get_test('13 September', '2017', 'Programmer\'s Day'),
    
    'autism sunday 2016' => get_test('14 February', '2016', 'Autism Sunday'),
    'international beer day 2015' => get_test('7 August', '2015', 'International Beer Day'),
    
    'mothers day 2015' => get_test('United States: 10 May, Norway: 8 February, Spain: 3 May, ' .
        'Argentina: 18 October, Russian Federation: 29 November', '2015', 'Mothers Day'),
    'mother\'s day 2016' => get_test('United States: 8 May, Norway: 14 February, Spain: 1 May, ' .
        'Argentina: 16 October, Russian Federation: 27 November', '2016', 'Mother\'s Day'),

    'Children\'s Day 2015' => get_test('United States: 14 June, United States: 7 June, Thailand: 10 January, New Zealand: 1 March, ' .
        'Spain: 10 May, Australia: 24 October, South Africa: 7 November', '2015', 'Children\'s Day'),
        
    'Father\'s Day 2015' => get_test('United States: 21 June, Romania: 10 May, ' .
        'Lithuania: 7 June, Austria: 14 June, Australia: 6 September', '2015', 'Father\'s Day'),

    'easter' => undef,
    'easter 123' => undef,
    'easter 2300' => undef,
    'easter 1799' => undef,
    'easter date 2000 date' => undef,
    'Rosh Hashanah' => undef,
    'Pesach' => undef,
    'Passover' => undef,
    'Passover 1799' => undef,
    'Rosh Hashanah 2300' => undef,
    'Jewish Holidays 9999' => undef,
    'Jewish Holidays' => undef
);

done_testing;
