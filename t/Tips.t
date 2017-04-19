#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'tip';
zci is_cached   => 1;

sub make_structured_answer {
    my ($type, $subtotal, $additive, $total) = @_;
        
    my ($title, $subtitle);
    if ($type eq 'percentage') {
        $title = "$total";
        $subtitle = "$total is $additive% of $subtotal";
    }
    else {
        $type = ucfirst($type);
        $title = "\$$additive";
        $subtitle = "Subtotal: \$$subtotal; $type: \$$additive; Total: \$$total";
    }
    
    return $title,
        structured_answer => {
            data => {
                title => "$title",
                subtitle => "$subtitle"
            },
            templates => {
                group => 'text'
            }
        };
}

sub build_test {test_zci(make_structured_answer(@_))}

ddg_goodie_test(
    [qw( DDG::Goodie::Tips)],
    '20% tip on $20'                  => build_test('tip', '20.00', '4.00', '24.00'),
    '20% tip on $20 bill'             => build_test('tip', '20.00', '4.00', '24.00'),
    '20% tip for a $20 bill'          => build_test('tip', '20.00', '4.00', '24.00'),
    '20 percent tip on $20'           => build_test('tip', '20.00', '4.00', '24.00'),
    '20% tip on $21.63'               => build_test('tip', '21.63', '4.33', '25.96'),
    '20 percent tip for a $20 bill'   => build_test('tip', '20.00', '4.00', '24.00'),
    '20 percent tip for a $2000 bill' => build_test('tip', '2,000.00', '400.00', '2,400.00'),
    '20% tax on $20'                  => build_test('tax', '20.00', '4.00', '24.00'),
    '25 percent of 20000'             => build_test('percentage', '20,000', '25', '5,000'),
    '2% of 25,000'                    => build_test('percentage', '25,000', '2', '500'),
    '2% of $25,000'                   => build_test('percentage', '$25,000', '2', '$500.00'),
    '2,000% of -2'                    => build_test('percentage', '-2', '2,000', '-40'),
    'best of 5'                       => undef,
    '4 of 5 dentists'                 => undef,
);

done_testing;
