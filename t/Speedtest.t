#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'speedtest';
zci is_cached   => 1;

sub build_structured_answer {
    my @test_params = @_;

    return '',
        structured_answer => {
        
            id => 'speed_test',

            data => {
                title    => 'Network Speed Test',
                subtitle => 'Powered By Fast - Netflix'
            },

            meta => {
                sourceName => 'Fast.com',
                sourceUrl => 'https://fast.com'
            },

            templates => {
                group => 'info',
                options => {
                    content => 'DDH.speedtest.content'
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Speedtest )],
    'speedtest' => build_test(),
    'internet' => undef,
);

done_testing;
