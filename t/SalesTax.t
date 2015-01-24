#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "sales_tax";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::SalesTax )],
    'sales tax for pennsylvania' => test_zci(
        'Pennsylvania sales tax: 6%',
        structured_answer => {
            input     => ['Pennsylvania'],
            operation => 'Sales Tax',
            result    => '6%'
        }
    ), 
    'what is sales tax for mississippi' => test_zci(
        'Mississippi sales tax: 7%',
        structured_answer => {
            input     => ['Mississippi'],
            operation => 'Sales Tax',
            result    => '7%'
            
            
        }
    ),   
    'what is the sales tax in kansas' => test_zci(
        'Kansas sales tax: 6.15%',
        structured_answer => {
            input     => ['Kansas'],
            operation => 'Sales Tax',
            result    => '6.15%'
            
            
        }
    ),     
    'sales tax pa' => test_zci(
        'Pennsylvania sales tax: 6%',
        structured_answer => {
            input     => ['Pennsylvania'],
            operation => 'Sales Tax',
            result    => '6%'
            
        }
    ),
    'sales tax connecticut' => test_zci(
        'Connecticut sales tax: 6.35%',
        structured_answer => {
            input     => ['Connecticut'],
            operation => 'Sales Tax',
            result    => '6.35%'
            
        }
    ),
    'sales tax delaware' => test_zci(
        'Delaware sales tax: Delaware does not levy a sales tax.',
        structured_answer => {
            input     => ['Delaware'],
            operation => 'Sales Tax',
            result    => 'Delaware does not levy a sales tax.'
            
        }
    ),
    'sales tax in japan' => undef,
    'what is the sales tax in china' => undef,
    'sales tax in connecticut what is' => undef
   );
done_testing;
