#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "coffee_to_water_ratio";
zci is_cached   => 1;


sub build_structured_answer {
    my ($input, $result) = @_;
    my ($title, $subtitle);
    if ($input eq '') {
        $subtitle = "Coffee to water ratio per gram (0.035 ounces)";
        $title = "16.7 ml (0.56 fl. oz.)";
    } else {
        $subtitle = "Water calculation for coffee weight: $input";
        $title = $result;
    }
    return $result,
        structured_answer => {
            data => {
                title    => $title,
                subtitle => $subtitle,
            },
            templates => {
                group => 'text',
            },
        },
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::CoffeeToWaterRatio )],

    '30g coffee to water'              => build_test('30g', "501 ml of water"),
    'coffee to water 30G'              => build_test('30G', "501 ml of water"),
    'coffee to water ratio 1 ounce'    => build_test('1ounce', "16 fl. oz. of water"),
    '31.2 grams coffee to water ratio' => build_test('31.2grams', "521 ml of water"),
    'coffee to water .5Oz'             => build_test('.5Oz', "8 fl. oz. of water"),
    'COFFEE TO WATER'                  => build_test('', "1 g to 16.7 ml (0.035 oz. to 0.56 fl. oz.)"),
    'coffee to water ratio'            => build_test('', "1 g to 16.7 ml (0.035 oz. to 0.56 fl. oz.)"),
    'coffee to water 20 rgams'         => build_test('20g', "334 ml of water"),
    'coffee to water 30 garms'         => build_test('30g', "501 ml of water"),
    '29387293847g coffee to water ratio' => undef,
    '29387293847 coffee to water ratio'  => undef,
    'coffee to water sdkmfsdkjfh'        => undef,
);

done_testing;
