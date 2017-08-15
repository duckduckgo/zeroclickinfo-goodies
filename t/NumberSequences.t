#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'number_sequences';
zci is_cached   => 1;

my $number_reg = '^[0-9]+$';
my $oeis_reg = '^OEIS$';
my $yes_no_reg = '^(Yes|No)$';

sub build_structured_answer {
    my ($answer, $title, $subtitle) = (undef, undef, undef);
    
    if ( $_[2] =~ /$number_reg/ ){
    
        my ($number, $type, $_title) = @_;
        $title = $_title;
        $answer = "$number $type is:";
        $subtitle = "$number $type number";

    } elsif ( $_[1] =~ /$oeis_reg/ ){

        my ($type, $_temp, $result) = @_;
        $answer = "OEIS Number for $type Sequence is:";
        $subtitle = "$type OEIS Number";
        $title = $result;

    } elsif ( $_[2] =~ /$yes_no_reg/ ){

        my ($number, $type, $result) = @_;
        $answer = "Is $number a $type number ?";
        $subtitle = ($result eq "Yes") ? 
                    "$result, $number is a $type number" :
                    "$result, $number is not a $type number";
        $title = $result;
    }
    return $answer,
           structured_answer => {

               data => {
                   title    => $title,
                   subtitle => $subtitle
               },

               templates => {
                   group => 'text',
               }
           };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
        [qw( DDG::Goodie::NumberSequences )],
        '5th prime number'         => build_test('5th', 'Prime', '11'),
        '5th prime number'         => build_test('5th', 'Prime', '11'),
        '1st prime number'         => build_test('1st', 'Prime', '2'),
        '10th prime number'        => build_test('10th', 'Prime', '29'),
        '10th number prime'        => build_test('10th', 'Prime', '29'),
        '10th prime'               => build_test('10th', 'Prime', '29'),
        '1,000th prime number'     => build_test('1000th', 'Prime', '7919'),
        '1,500th prime number'     => build_test('1500th', 'Prime', '12553'),
        '5th catalan number'       => build_test('5th', 'Catalan', '42'),
        '5st catalan number'       => build_test('5th', 'Catalan', '42'),
        '5th Tetrahedral number'   => build_test('5th', 'Tetrahedral', '35'),
        '5st Tetrahedral number'   => build_test('5th', 'Tetrahedral', '35'),
        '1st Square number'        => build_test('1st', 'Square', '1'),
        '1st Cube number'          => build_test('1st', 'Cube', '1'),
        '1st Pronic number'        => build_test('1st', 'Pronic', '2'),
        '1st Triangular number'    => build_test('1st', 'Triangular', '1'),
        '1st Star number'          => build_test('1st', 'Star', '1'),
        '1st Even number'          => build_test('1st', 'Even', '2'),
        '1st Odd number'           => build_test('1st', 'Odd', '3'),
        '1st Abundant number'      => build_test('1st', 'Abundant', '12'),
        '1st Factorial number'     => build_test('1st', 'Factorial', '1'),
        '1st Primorial number'     => build_test('1st', 'Primorial', '2'),
        '1st Fibonacci number'     => build_test('1st', 'Fibonacci', '1'),
        '1st Lucas number'         => build_test('1st', 'Lucas', '1'),
        '1st Fibbinary number'     => build_test('1st', 'Fibbinary', '1'),
        '1st Pell number'          => build_test('1st', 'Pell', '1'),
#        '1st Tribonacci number'    => build_test('1st', 'Tribonacci', '0'),
        '2nd Tribonacci number'    => build_test('2nd', 'Tribonacci', '1'),
        '3rd Tribonacci number'    => build_test('3rd', 'Tribonacci', '1'),
        '4th Tribonacci number'    => build_test('4th', 'Tribonacci', '2'),
#        '1st Perrin number'        => build_test('1st', 'Perrin', '0'),
        '2nd Perrin number'        => build_test('2nd', 'Perrin', '2'),
        '3rd Perrin number'        => build_test('3rd', 'Perrin', '3'),
        '4th Perrin number'        => build_test('4th', 'Perrin', '2'),
#        '1st Palindrome number'    => build_test('1st', 'Palindrome', '0'),
        '2nd Palindrome number'    => build_test('2nd', 'Palindrome', '1'),
        '3rd Palindrome number'    => build_test('3rd', 'Palindrome', '2'),
        '4th Palindrome number'    => build_test('4th', 'Palindrome', '3'),
#        '1st Xenodrome number'     => build_test('1st, 'Xenodrome', '0'),
        '2nd Xenodrome number'     => build_test('2nd', 'Xenodrome', '1'),
        '3rd Xenodrome number'     => build_test('3rd', 'Xenodrome', '2'),
        '4th Xenodrome number'     => build_test('4th', 'Xenodrome', '3'),
        '1st Beastly number'       => build_test('1st', 'Beastly', '666'),
        '1st Undulating number'    => build_test('1st', 'Undulating', '1'),
        '1st Harshad number'       => build_test('1st', 'Harshad', '1'),
        '1st Moran number'         => build_test('1st', 'Moran', '18'),
        '1st Happy number'         => build_test('1st', 'Happy', '1'),
        '1st Cullen number'        => build_test('1st', 'Cullen', '3'),
        '1st Proth number'         => build_test('1st', 'Proth', '3'),
        '1st Woodall number'       => build_test('1st', 'Woodall', '1'),
        '1st Klarnerrado number'   => build_test('1st', 'Klarnerrado', '1'),
        '1st Ulam number'          => build_test('1st', 'Ulam', '1'),
        '1st Lucky number'         => build_test('1st', 'Lucky', '1'),
        '1st Aronson number'       => build_test('1st', 'Aronson', '1'),
        '1st Duffinian number is?' => build_test('1st', 'Duffinian', '4'),
        'oeis number for prime'    => build_test('Prime', 'OEIS', 'A000040'),
        'oeis prime'               => build_test('Prime', 'OEIS', 'A000040'),
        'is 5 prime?'              => build_test('5', 'Prime', 'Yes'),
        '5 prime?'                 => build_test('5', 'Prime', 'Yes'),
        '15 prime?'                => build_test('15', 'Prime', 'No'),
        '10 fibonacci number?'     => build_test('10', 'Fibonacci', 'No'),
        '5th duck number'          => undef,
        '10th 10 prime'            => undef 
        );

done_testing;
