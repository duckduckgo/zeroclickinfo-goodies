#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'website_status_check';
zci is_cached   => 1;

sub build_structured_answer {
    my @test_params = @_;

     return '',
        structured_answer => {
            id => "website_status_check",
            data => {
                title    => 'Website Status Check',
                subtitle => 'Enter website url to check if it is up'
            },

            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.website_status_check.content'
                }
            }
        };
}

ddg_goodie_test(
    [qw( DDG::Goodie::WebsiteStatusCheck )],
    'website status' => build_test(undef),
);

done_testing;

