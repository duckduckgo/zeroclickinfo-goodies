#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'conversions';

ddg_goodie_test(
    [
        'DDG::Goodie::Conversions'
    ],
    
    # @todo: could create a complete test suite for all toUnits->fromUnits

    'convert 5 oz to g'            => test_zci('5 oz is 141.747462720417 g',),
    'convert 1 ton to long ton'    => test_zci('1 ton is 0.892858633233845 long ton',),
    'convert 158 ounce to lbm'     => test_zci('158 ounce is 9.87497760390089 lbm',),
    'convert 0.111 stone to pound' => test_zci('0.111 stone is 1.55399859023452 pound',),
    'mcg to mcg'                   => test_zci('1 mcg is 1 mcg',),
    '3 kilogramme to pound'        => test_zci('3 kilogramme is 6.61386 pound',),
    '1.3 metric ton to short ton'  => test_zci('1.3 metric ton is 1.433 short ton',),
    'stone pound'                  => test_zci('1 stone is 13.9999872994101 pound',),
);

done_testing;
