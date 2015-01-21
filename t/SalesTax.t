#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "sales_tax";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::SalesTax )],
            
    'Sales tax for pennsylvania' => test_zci(
        'Pennsylvania sales tax: 6%',
        structured_answer => {
            input     => ['Pennsylvania'],
            operation => 'Sales tax for',
            result    => '6%'
        }
    ), 
    'what is sales tax for mississippi' => test_zci(
        'Mississippi sales tax: 7%',
        structured_answer => {
            input     => ['Mississippi'],
            operation => 'Sales tax for',
            result    => '7%'
            
            
        }
    ),    
    'sales tax pa' => test_zci(
        'Pennsylvania sales tax: 6%',
        structured_answer => {
            input     => ['Pennsylvania'],
            operation => 'Sales tax for',
            result    => '6%'
            
        }
    ),
    
    'sales tax in japan' => undef
    
    
   
   );
done_testing;
