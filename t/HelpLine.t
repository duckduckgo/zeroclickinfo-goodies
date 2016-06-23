#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use DDG::Test::Location;
use DDG::Request;

zci answer_type => 'helpline';
zci is_cached   => 0;

sub build_structured_answer{
    my ($result, $num, $country) = @_;
    return "24 Hour Suicide Hotline$num $country",
        structured_answer => {
            data => {
                title => "24 Hour Suicide Hotline$num $country",
                record_data => $result,
            },
            templates => {
                group => "list",
                options => {
                    content => 'record',
                }
          }
        }
}

sub build_test{test_zci( build_structured_answer(@_))}

my @test_us = ({
        'National Suicide Prevention Lifeline' => "1-800-273-TALK (8255)"
    }, '', 'in the U.S.');
my @test_de = ({
        'Telefonseelsorge' => "0800 111 0 111 (or 222)"
    }, '', 'in Germany');
my @test_au = ({
        'Lifeline' => "13 11 14",
        'Kids Helpline' => "1800 55 1800"
    }, 's', 'in Australia');

ddg_goodie_test(
    [qw(
	DDG::Goodie::HelpLine
    )],

    DDG::Request->new(
        query_raw => 'suicide',
        location => test_location('us'),
    ),
    build_test(@test_us),
     
    DDG::Request->new(
        query_raw => 'kill myself',
        location => test_location('de'),
    ),
    build_test(@test_de),
    
    DDG::Request->new(
        query_raw => 'suicide hotline',
        location => test_location('au'),
    ),
    build_test(@test_au),
    
    DDG::Request->new(
        query_raw => 'suicide prevention',
        location => test_location('us'),
    ),
    build_test(@test_us),
    
    DDG::Request->new(
        query_raw => 'end my life',
        location => test_location('au'),
    ),
    build_test(@test_au),

    DDG::Request->new(
        query_raw => 'i want to kill myself',
        location => test_location('us'),
    ),
    build_test(@test_us),

    DDG::Request->new(
        query_raw => 'commit suicide',
        location => test_location('au'),
    ),
    build_test(@test_au),

    DDG::Request->new(
        query_raw => 'suicide pills',
        location => test_location('de'),
    ),
    build_test(@test_de),

    DDG::Request->new(
        query_raw => 'suicidal ideation',
        location => test_location('de'),
    ),
    build_test(@test_de),

    DDG::Request->new(
        query_raw => 'suicide silence',
        location => test_location('us'),
    ),
    undef
 );

done_testing;
