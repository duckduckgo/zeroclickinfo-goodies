#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'base64_conversion';
zci is_cached   => 1;

my @foo_encoded = test_zci(
    'Base64 encoded: Zm9v',
    structured_answer => {
        input     => ['foo'],
        operation => 'Base64 encode',
        result    => 'Zm9v'
    });

my @this_text_encoded = test_zci(
    'Base64 encoded: dGhpcyB0ZXh0',
    structured_answer => {
        input     => ['this text'],
        operation => 'Base64 encode',
        result    => 'dGhpcyB0ZXh0'
    });

my @dGhpcyB0ZXh0_decoded = test_zci(
    'Base64 decoded: this text',
    structured_answer => {
        input     => ['dGhpcyB0ZXh0'],
        operation => 'Base64 decode',
        result    => 'this text'
    });

ddg_goodie_test(
    [qw( DDG::Goodie::Base64)],
    # It encodes
    'base64 encode foo'       => @foo_encoded,
    'base64 ENCoDE foo'       => @foo_encoded,
    'base64 foo'              => @foo_encoded,
    "base64 encode this text" => @this_text_encoded,
    
    # It decodes
    "base64 decode dGhpcyB0ZXh0" => @dGhpcyB0ZXh0_decoded,
    "base64 dECoDE dGhpcyB0ZXh0" => @dGhpcyB0ZXh0_decoded,
    
    # It ignores 'base64' at end of query
    "python base64" => undef,
    
    # It ignores incomplete requests to process
    "base64" => undef,
    "base64 encode" => undef,
    "base64 decode" => undef,
);

done_testing;
