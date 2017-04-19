#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'calc';
zci is_cached   => 1;

sub build_test
{
    my ($query_expression) = @_;
    return test_zci('', structured_answer => {
        data => {
            query => $query_expression
        },
        templates => {
            group => 'base',
            options => {
                content => 'DDH.calculator.content'
            }
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Calculator )],

    # Non expression type queries
    # These should return undef because the query isn't a valid expression
    'calc'                      => build_test(undef),
    'calculator'                => build_test(undef),
    'online calculator'         => build_test(undef),
    'calculator online free'    => build_test(undef),
    'free online calculator'    => build_test(undef),
    
    ## These queries shouldn't trigger the calculator
    '123.123.123.123/255.255.255.255' => undef,
    '83.166.167.160/27'               => undef,
    '9 + 0 x 0xbf7'                   => undef,
    '0x07'                            => undef,
    'sin(1.0) + 1,05'                 => undef,
    '5234534.34.54+1'                 => undef,
    '//'                              => undef,
    dividedbydividedby                => undef,
    time                              => undef,    # We eval perl directly, only do whitelisted stuff!
    'four squared'                    => undef,
    '! + 1'                           => undef,    # Regression test for bad query trigger.
    '$5'                              => undef,
    'calculate 5'                     => undef,
    'solve $50'                       => undef,
    '382-538-2546'                    => undef,    # Calling DuckDuckGo
    '(382) 538-2546'                  => undef,
    '382-538-2546 x1234'              => undef,
    '1-382-538-2546'                  => undef,
    '+1-(382)-538-2546'               => undef,
    '382.538.2546'                    => undef,
    '+38-2538111111'                  => undef,
    '+382538-111-111'                 => undef,
    '+38 2538 111-111'                => undef,
    '01780-111-111'                   => undef,
    '01780-111-111x400'               => undef,
    '(01780) 111 111'                 => undef,
    'warn "hi"; 1 + 1'                => undef,
    'die "killed"; 1 + 3'             => undef,
    '1 + 1; die'                      => undef,
    '`ls -al /`; 3 * 4'               => undef,
    '1()'                             => undef,
    '1^()'                            => undef,
    '1^($)'                           => undef,
    '1/*-+'                           => undef,
    'http://'                         => undef,
    'word+word'                       => undef,
    'word + word'                     => undef,
    'mxtoolbox'                       => undef,
    'fx-es'                           => undef,
    '-2'                              => undef,
    '-0'                              => undef,
    'm.box.com'                       => undef,
);

done_testing;
