#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'base64_conversion';
zci is_cached   => 1;

sub build_structured_answer {
    my ($input, $operation, $output) = @_;
    return "$operation d: $output",
      structured_answer => {
          data => {
              title => $output,
              subtitle => "$operation: $input"
          },
          templates => {
              group => 'text'
          }
    };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Base64)],
    # It encodes
    'base64 encode foo'       => build_test('foo', 'Base64 encode', 'Zm9v'),
    'base64 ENCoDE foo'       => build_test('foo', 'Base64 encode', 'Zm9v'),
    'base64 foo'              => build_test('foo', 'Base64 encode', 'Zm9v'),
    "base64 encode this text" => build_test('this text', 'Base64 encode', 'dGhpcyB0ZXh0'),
    
    # It decodes
    "base64 decode dGhpcyB0ZXh0" => build_test('dGhpcyB0ZXh0', 'Base64 decode', 'this text'),
    "base64 dECoDE dGhpcyB0ZXh0" => build_test('dGhpcyB0ZXh0', 'Base64 decode', 'this text'),
    
    # It ignores 'base64' at end of query
    "python base64" => undef,
    
    # It ignores incomplete requests to process
    "base64" => undef,
    "base64 encode" => undef,
    "base64 decode" => undef,
);

done_testing;
