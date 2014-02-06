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

    'convert 5 oz to g'            => test_zci('5 oz is 141.747 g',),
    'convert 1 ton to long ton'    => test_zci('1 ton is 0.893 long ton',),
    'convert 158 ounce to lbm'     => test_zci('158 ounce is 9.875 lbm',),
    'convert 0.111 stone to pound' => test_zci('0.111 stone is 1.554 pound',),
    'mcg to mcg'                   => test_zci('1 mcg is 1.000 mcg',),
    '3 kilogramme to pound'        => test_zci('3 kilogramme is 6.614 pound',),
    '1.3 tonnes to ton'            => test_zci('1.3 tonne is 1.433 ton',),
    'stone pound'                  => test_zci('1 stone is 14.000 pound',),
    'gram pound convert'           => test_zci('1 gram is 0.002 pound',),
    "convert 1 ton to long ton"    => test_zci('1 ton is 0.893 long ton',),
    'puff toke to kludge'          => undef,
);

done_testing;
