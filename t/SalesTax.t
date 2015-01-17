#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "sales_tax";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::SalesTax )],
            
    'pennsylvania sales tax' => test_zci(
        'Pennsylvania sales tax: 6%',
        structured_answer => {
            input     => ['Pennsylvania'],
            operation => 'Sales tax for',
            result    => '6%'
        }
    ),
          
        'Rhode Island sales tax' => test_zci(
        'Rhode Island sales tax: 7%',
        structured_answer => {
            input     => ['Rhode Island'],
            operation => 'Sales tax for',
            result    => '7%'
            
            
        }
    ),    
    'Alaska sales tax' => test_zci(
        'Alaska sales tax: Alaska does not levy a sales tax.',
        structured_answer => {
            input     => ['Alaska'],
            operation => 'Sales tax for',
            result    => 'Alaska does not levy a sales tax.'
            
            }
            ),
);

done_testing;
