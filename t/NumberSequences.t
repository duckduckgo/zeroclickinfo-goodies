#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'number_sequences';
zci is_cached   => 1;

sub build_structured_answer {
#    my ($raw_number, $type, $number, $result) = @_;
    my ($answer, $subtitle, $title) = @_;
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
        '5th prime number'         => build_test('5th Prime is:', '5th Prime number', '11'),
        '1st prime number'         => build_test('1st Prime is:', '1st Prime number', '2'),
        '10th prime number'        => build_test('10th Prime is:', '10th Prime number', '29'),
        '10th number prime'        => build_test('10th Prime is:', '10th Prime number', '29'),
        '10th prime'               => build_test('10th Prime is:', '10th Prime number', '29'),
        '1,000th prime number'     => build_test('1000th Prime is:', '1000th Prime number', '7919'),
        '1,500th prime number'     => build_test('1500th Prime is:', '1500th Prime number', '12553'),
        '5th catalan number'       => build_test('5th Catalan is:', '5th Catalan number', '42'),
        '5st catalan number'       => build_test('5th Catalan is:', '5th Catalan number', '42'),
        '5th Tetrahedral number'   => build_test('5th Tetrahedral is:', '5th Tetrahedral number', '35'),
        '5st Tetrahedral number'   => build_test('5th Tetrahedral is:', '5th Tetrahedral number', '35'),
        '1st Square number'        => build_test('1st Square is:', '1st Square number', '1'),
        '1st Cube number'          => build_test('1st Cube is:', '1st Cube number', '1'),
        '1st Pronic number'        => build_test('1st Pronic is:', '1st Pronic number', '2'),
        '1st Triangular number'    => build_test('1st Triangular is:', '1st Triangular number', '1'),
        '1st Star number'          => build_test('1st Star is:', '1st Star number', '1'),
        '1st Even number'          => build_test('1st Even is:', '1st Even number', '2'),
        '1st Odd number'           => build_test('1st Odd is:', '1st Odd number', '3'),
        '1st Abundant number'      => build_test('1st Abundant is:', '1st Abundant number', '12'),
        '1st Factorial number'     => build_test('1st Factorial is:', '1st Factorial number', '1'),
        '1st Primorial number'     => build_test('1st Primorial is:', '1st Primorial number', '2'),
        '1st Fibonacci number'     => build_test('1st Fibonacci is:', '1st Fibonacci number', '1'),
        '1st Lucas number'         => build_test('1st Lucas is:', '1st Lucas number', '1'),
        '1st Fibbinary number'     => build_test('1st Fibbinary is:', '1st Fibbinary number', '1'),
        '1st Pell number'          => build_test('1st Pell is:', '1st Pell number', '1'),
#        '1st Tribonacci number'    => build_test('1st', 'Tribonacci', '1', '0'),
        '2nd Tribonacci number'    => build_test('2nd Tribonacci is:', '2nd Tribonacci number', '1'),
        '3rd Tribonacci number'    => build_test('3rd Tribonacci is:', '3rd Tribonacci number', '1'),
        '4th Tribonacci number'    => build_test('4th Tribonacci is:', '4th Tribonacci number', '2'),
#        '1st Perrin number'        => build_test('1st', 'Perrin', '1', '0'),
        '2nd Perrin number'        => build_test('2nd Perrin is:', '2nd Perrin number', '2'),
        '3rd Perrin number'        => build_test('3rd Perrin is:', '3rd Perrin number', '3'),
        '4th Perrin number'        => build_test('4th Perrin is:', '4th Perrin number', '2'),
#        '1st Palindrome number'    => build_test('1th', 'Palindrome', '1', '0'),
        '2nd Palindrome number'    => build_test('2nd Palindrome is:', '2nd Palindrome number', '1'),
        '3rd Palindrome number'    => build_test('3rd Palindrome is:', '3rd Palindrome number', '2'),
        '4th Palindrome number'    => build_test('4th Palindrome is:', '4th Palindrome number', '3'),
#        '1st Xenodrome number'     => build_test('1st', 'Xenodrome', '1', '0'),
        '2nd Xenodrome number'     => build_test('2nd Xenodrome is:', '2nd Xenodrome number', '1'),
        '3rd Xenodrome number'     => build_test('3rd Xenodrome is:', '3rd Xenodrome number', '2'),
        '4th Xenodrome number'     => build_test('4th Xenodrome is:', '4th Xenodrome number', '3'),
        '1st Beastly number'       => build_test('1st Beastly is:', '1st Beastly number', '666'),
        '1st Undulating number'    => build_test('1st Undulating is:', '1st Undulating number', '1'),
        '1st Harshad number'       => build_test('1st Harshad is:', '1st Harshad number', '1'),
        '1st Moran number'         => build_test('1st Moran is:', '1st Moran number', '18'),
        '1st Happy number'         => build_test('1st Happy is:', '1st Happy number', '1'),
        '1st Cullen number'        => build_test('1st Cullen is:', '1st Cullen number', '3'),
        '1st Proth number'         => build_test('1st Proth is:', '1st Proth number', '3'),
        '1st Woodall number'       => build_test('1st Woodall is:', '1st Woodall number', '1'),
        '1st Klarnerrado number'   => build_test('1st Klarnerrado is:', '1st Klarnerrado number', '1'),
        '1st Ulam number'          => build_test('1st Ulam is:', '1st Ulam number', '1'),
        '1st Lucky number'         => build_test('1st Lucky is:', '1st Lucky number', '1'),
        '1st Aronson number'       => build_test('1st Aronson is:', '1st Aronson number', '1'),
        '1st Duffinian number is?' => build_test('1st Duffinian is:', '1st Duffinian number', '4'),
        'oeis number for prime'    => build_test('OEIS Number for Prime Sequence is:', 'Prime OEIS Number', 'A000040'),
        'oeis prime'               => build_test('OEIS Number for Prime Sequence is:', 'Prime OEIS Number', 'A000040'),
        'is 5 prime?'              => build_test('Is 5 a Prime number ?', 'Yes, 5 is a Prime number', 'Yes'),
        '5 prime?'                 => build_test('Is 5 a Prime number ?', 'Yes, 5 is a Prime number', 'Yes'),
        '15 prime?'                => build_test('Is 15 a Prime number ?', 'No, 15 is not a Prime number', 'No'),
        '10 fibonacci number?'     => build_test('Is 10 a Fibonacci number ?', 'No, 10 is not a Fibonacci number', 'No'),
        '5th duck number'          => undef,
        '10th 10 prime'            => undef 
        );

done_testing;
