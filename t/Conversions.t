#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

ddg_goodie_test(
    [
        'DDG::Goodie::Conversions'
    ],
    
    # @todo: could create a complete test suite for all toUnits->fromUnits

    # failure cases first, as they are most important ...
    # [ 1]: good $factor, bad $toUnits, bad $fromUnits
    'convert 12 pipes to tokes' =>
        test_zci(
            '',
        );
    
    # [ 2]: good $factor, bad $toUnits, good $fromUnits
    'convert 0.99 dogs to ounces' =>
        test_zci(
            '',
        );
    
    # [ 3]: good $factor, good $toUnits, bad $fromUnits
    'convert 1 ton to kitty litter' =>
        test_zci(
            '',
        );
    
    # [ 4]: bad $factor, bad $toUnits, bad $fromUnits
    'convert bradley david to andersen' =>
        test_zci(
            '',
        );
    
    # [ 5]: bad $factor, bad $toUnits, good $fromUnits
    'convert ddg ducks to metric tons' =>
        test_zci(
            '',
        );
    
    # [ 6]: bad $factor, good $toUnits, bad $fromUnits
    'convert soil grams to beans' =>
        test_zci(
            '',
        );

    # and now a few success cases ... let's round it up to 10:
    # [ 7]: good $factor, good $toUnits, good $fromUnits
    'convert 5 oz to g' =>
        test_zci(
            '5 ozs is 141.747462720417 gs.',
        );
    
    # [ 8]: good $factor, good $toUnits, good $fromUnits
    'convert 1 ton to long tons' =>
        test_zci(
            '1 ton is 0.892858633233845 long ton.',
        );

    # [ 9]: good $factor, good $toUnits, good $fromUnits
    'convert 158 ounces to lbms' =>
        test_zci(
            '158 ounces is 9.87497760390089 lbms.',
        );

    # [10]: good $factor, good $toUnits, good $fromUnits
    'convert 0.111 stone to pound' =>
        test_zci(
            '0.111 stone is 1.55399859023452 pounds.',
        );
);

done_testing;
