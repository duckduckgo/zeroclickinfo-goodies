#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'potus';
zci is_cached   => 1;

sub build_test
{
    my ($who, $article, $number) = @_;
    
    return test_zci("$who $article the $number President of the United States", structured_answer => {
        data => {
            title => $who,
            subtitle => "$number President of the United States"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::POTUS)],
    'who is the president of the united states' => build_test('Donald J. Trump', 'is',"45th"),
    'who was the president of the united states' => build_test('Barack Obama', 'was', '44th'),
    'who is president of the united states' => build_test('Donald J. Trump', 'is',"45th"),
    'who is the fourth president of the united states' => build_test('James Madison', 'was', '4th'),
    'who is the nineteenth president of the united states' => build_test('Rutherford B. Hayes', 'was','19th'),
    'who was the 1st president of the united states' => build_test('George Washington', 'was', '1st'),
    'who was the 31 president of the united states' => build_test('Herbert Hoover', 'was', '31st'),
    'who was the 22 president of the united states' => build_test('Grover Cleveland', 'was','22nd'),
    'potus 11' => build_test('James K. Polk', 'was','11th'),
    'POTUS 24' => build_test('Grover Cleveland', 'was', '24th'),
    'who was the twenty-second POTUS?' => build_test('Grover Cleveland', 'was', '22nd'),
    'potus 16' => build_test('Abraham Lincoln', 'was', '16th'),
    'who is the vice president of the united states?' => undef,
    'vice president of the united states' => undef,
    'who is the worst president of the united states' => undef,
    'who is the president elect of the united states' => undef,
    'who is the president-elect of the us' => undef,
    'VPOTUS' => undef
);

done_testing;
