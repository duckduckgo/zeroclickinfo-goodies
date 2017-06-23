#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'tip';
zci is_cached   => 1;

sub make_structured_answer {
    my ($percentage, $bill_amount) = @_;
    
    return '', structured_answer => {
        data => {
            title => "Tip Calculator",
            percentage => "$percentage",
            bill => "$bill_amount",
        },
        templates => {
            group => 'text',
            options => {
                content => 'DDH.tips.content'
            },
        }
    };
}

sub build_test {test_zci(make_structured_answer(@_))}

ddg_goodie_test(
    [qw( DDG::Goodie::Tips)],
    '20% tip on $20'                  => build_test('20', '20'),
    '20% tip on $20 bill'             => build_test('20', '20'),
    '20% tip for a $20 bill'          => build_test('20', '20'),
    '20 percent tip on $20'           => build_test('20', '20'),
    '20% tip on $21.63'               => build_test('20', '21.63'),
    '20 percent tip for a $20 bill'   => build_test('20', '20'),
    '20 percent tip for a $2000 bill' => build_test('20', '2000'),
    'tip calculator'                  => build_test('', ''), # undef stringified
    'calculate tip'                   => build_test('', ''), # undef stringified
    # queries that will be handled by the calc
    '25 percent of 20000'             => undef,
    '2% of 25,000'                    => undef,
    '2% of $25,000'                   => undef,
    '2,000% of -2'                    => undef,
    '20% tax on $20'                  => undef,
    # random. definately shouldn't trigger this IA
    'best of 5'                       => undef,
    '4 of 5 dentists'                 => undef,
    'yo, give me some tips'           => undef,
    'tips to save cash'               => undef,
    'show me the tip calculator, bro' => undef,
);

done_testing;
