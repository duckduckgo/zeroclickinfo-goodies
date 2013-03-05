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
        	heading => 'CarFax',
        	html => "Check the automobile's VIN at <a href='http://www.carfax.com/cfm/check_order.cfm?VIN=1G8GG35M1G7123101&PopUpStatus=0'>CarFax</a>."
        ),
        'vin 1g8gg35m1g7123101' => test_zci(
        	"1G8GG35M1G7123101",
        	heading => 'CarFax',
        	html => "Check the automobile's VIN at <a href='http://www.carfax.com/cfm/check_order.cfm?VIN=1G8GG35M1G7123101&PopUpStatus=0'>CarFax</a>."
        ),
        '1g8gg35m1g7123101 vehicle identification number' => test_zci(
        	"1G8GG35M1G7123101",
        	heading => 'CarFax',
        	html => "Check the automobile's VIN at <a href='http://www.carfax.com/cfm/check_order.cfm?VIN=1G8GG35M1G7123101&PopUpStatus=0'>CarFax</a>."
        ),
        '1g8gg35m1g7123101 tracking' => test_zci(
        	"1G8GG35M1G7123101",
        	heading => 'CarFax',
        	html => "Check the automobile's VIN at <a href='http://www.carfax.com/cfm/check_order.cfm?VIN=1G8GG35M1G7123101&PopUpStatus=0'>CarFax</a>."
        ),
);

done_testing;

