#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'download_time_calculator';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my ($speedval, $dataval, $spdunit, $dtunit) = @_;

    return '', structured_answer => {

            data => {
                title    => 'Download Time Calculator',
                speed => "$speedval",
                data => "$dataval",
                speedUnit => $spdunit,
                dataUnit => $dtunit,
            },
            
            templates => {
                group => 'text',
                options => {
                    content => 'DDH.download_time_calculator.content'
                }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::DownloadTimeCalculator )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'data transfer' => build_test('', '', '', ''),
    '50 mb at 2 mbps' => build_test('2', '50', 1e6, 1e6),
    'download time calculator 50 GB at 2 megabytes per second' => build_test('2', '50', 8e6, 8e9),
    'downloading 1 terabyte of data at 50mbps' => build_test('50', '1', 1e6, 8e12),
    # Shouldn't trigger
    'how to download 50 gb' => undef,
    'Download some app' => undef,
    'bad example query' => undef,
);

done_testing;
