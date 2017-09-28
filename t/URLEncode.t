#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use Test::Deep;
use HTML::Entities;
use DDG::Test::Goodie;

zci answer_type => 'encoded_url';
zci is_cached   => 1;

sub build_structured_answer {
    my @test_params = @_;

    return '',
        structured_answer => {
            data => {
                title => 'URL Encoder/Decoder',
                subtitle => 'Enter URL below, then click the button to encode it'
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.urlencode.content'
                }
            }
        }
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw(DDG::Goodie::URLEncode)],

    'url encode' => build_test(),
    'encode url' => build_test(),
    'urlencode' => build_test(),
    'encodeurl' => build_test(),
    'url escape' => build_test(),
    'escape url' => build_test(),
    'urlescape' => build_test(),
    'escapeurl' => build_test(),
    'uri encode' => build_test(),
    'encode uri' => build_test(),
    'uriencode' => build_test(),
    'encodeuri' => build_test(),
    'uri escape' => build_test(),
    'escape uri' => build_test(),
    'uriescape' => build_test(),
    'escapeuri' => build_test(),

    'url decode' => build_test(),
    'decode url' => build_test(),
    'urldecode' => build_test(),
    'decodeurl' => build_test(),
    'uri decode' => build_test(),
    'decode uri' => build_test(),
    'uridecode' => build_test(),
    'decodeuri' => build_test(),
);

done_testing;
