#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'tip';
zci is_cached   => 1;

sub with_tax_response {
    my ($subtotal, $tax, $total) = @_;
    
    return "Subtotal: \$$subtotal; Tax: \$$tax; Total: \$$total";
}

sub with_tip_response {
    my ($subtotal, $tip, $total) = @_;
    
    return "Subtotal: \$$subtotal; Tip: \$$tip; Total: \$$total";
}

sub with_percentage_answer {
    my ($input, $percentage, $calculated_answer) = @_;
    
    return "$calculated_answer is $percentage% of $input";
}

sub make_structured_answer {
    my ($answer) = @_;
    
    return $answer,
        structured_answer => {
            data => {
                title => "$answer",
            },
            templates => {
                group => 'text'
            }
        };
}

ddg_goodie_test(
    [qw( DDG::Goodie::Tips)],
    '20% tip on $20'                  => test_zci(make_structured_answer(with_tip_response('20.00', '4.00', '24.00'))),
    '20% tip on $20 bill'             => test_zci(make_structured_answer(with_tip_response('20.00', '4.00', '24.00'))),
    '20% tip for a $20 bill'          => test_zci(make_structured_answer(with_tip_response('20.00', '4.00', '24.00'))),
    '20 percent tip on $20'           => test_zci(make_structured_answer(with_tip_response('20.00', '4.00', '24.00'))),
    '20% tip on $21.63'               => test_zci(make_structured_answer(with_tip_response('21.63', '4.33', '25.96'))),
    '20 percent tip for a $20 bill'   => test_zci(make_structured_answer(with_tip_response('20.00', '4.00', '24.00'))),
    '20 percent tip for a $2000 bill' => test_zci(make_structured_answer(with_tip_response('2,000.00', '400.00', '2,400.00'))),
    '20% tax on $20'                  => test_zci(make_structured_answer(with_tax_response('20.00', '4.00', '24.00'))),
    '25 percent of 20000'             => test_zci(make_structured_answer(with_percentage_answer('20,000', '25', '5,000'))),
    '2% of 25,000'                    => test_zci(make_structured_answer(with_percentage_answer('25,000', '2', '500'))),
    '2% of $25,000'                   => test_zci(make_structured_answer(with_percentage_answer('$25,000', '2', '$500.00'))),
    '2,000% of -2'                    => test_zci(make_structured_answer(with_percentage_answer('-2', '2,000', '-40'))),
    'best of 5'                       => undef,
    '4 of 5 dentists'                 => undef,
);

done_testing;
