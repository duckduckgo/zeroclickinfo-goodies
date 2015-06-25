#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'vin';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::VIN )],
        '1g8gg35m1g7123101' => test_zci(
        	"1G8GG35M1G7123101",
        	heading => 'Vehicle Identification Number',
        	html => "Check the automobile's VIN at <a href='http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101'>Decode This</a>."
        ),
        'vin 1g8gg35m1g7123101' => test_zci(
        	"1G8GG35M1G7123101",
        	heading => 'Vehicle Identification Number',
        	html => "Check the automobile's VIN at <a href='http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101'>Decode This</a>."
        ),
        '1g8gg35m1g7123101 vehicle identification number' => test_zci(
        	"1G8GG35M1G7123101",
        	heading => 'Vehicle Identification Number',
        	html => "Check the automobile's VIN at <a href='http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101'>Decode This</a>."
        ),
        '1g8gg35m1g7123101 tracking' => test_zci(
        	"1G8GG35M1G7123101",
        	heading => 'Vehicle Identification Number',
        	html => "Check the automobile's VIN at <a href='http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101'>Decode This</a>."
        ),
);

done_testing;

