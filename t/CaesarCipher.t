#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'caesar_cipher';
zci is_cached   => 1;

my $decode_response = {
          id   => 'caesar_cipher',
          name => 'Answer',
          data => '-ANY-', # We only need to check it is the right template.
          meta => {
              sourceUrl  => 'https://en.wikipedia.org/wiki/Caesar_cipher',
              sourceName => 'Wikipedia',
          },
          templates => {
              group   => 'info',
              options => {
                  content      => 'DDH.caesar_cipher.content',
                  chompContent => 1,
              },
          },
      };

sub decode_response {
    return "Caesar Cipher", structured_answer => $decode_response;
}

sub build_structured_answer {
    my ($result, $amount, $to_cipher) = @_;
    return "$result",
      structured_answer => {
          id   => 'caesar_cipher',
          name => 'Answer',
          data => {
              title    => "$result",
              subtitle => "Caesar cipher $amount $to_cipher",
          },
          templates => {
              group  => 'text',
              moreAt => 0,
          },
      };
}

sub build_test { test_zci(build_structured_answer(@_)) }
sub decode_test { test_zci(decode_response()) }

ddg_goodie_test(
    [qw( DDG::Goodie::CaesarCipher )],
    'caesar 2 abc'                => build_test('cde', 2, 'abc'),
    'caesar cipher -2 cde'        => build_test('abc', -2, 'cde'),
    'caesar 52 abc'               => build_test('abc', 52, 'abc'),
    'caesar 1 TtEeSsTt'           => build_test('UuFfTtUu', 1, 'TtEeSsTt'),
    'caesar 0 test'               => build_test('test', 0, 'test'),
    'caesar -26 test\\'           => build_test('test\\', -26, 'test\\'),
    'caesar 5 #test{]17TEST#'     => build_test('#yjxy{]17YJXY#', 5, '#test{]17TEST#'),
    'Caesar cipher 26 test text.' => build_test('test text.', 26, 'test text.'),
    'ceasar 13 "More Test Text"'  => build_test('"Zber Grfg Grkg"', 13, '&quot;More Test Text&quot;'),
    'shift cipher 7 Mxlm mxqm'    => build_test('Test text', 7, 'Mxlm mxqm'),
    'caesar cipher hello'         => undef,
    'caesar cipher'               => undef,
    # Decoding information tests
    'how to decode a caesar cipher?'   => decode_test(),
    'How to decode a Caesar cipher?'   => decode_test(),
    'how to use a shift cipher'        => decode_test(),
    'how to encrypt the caesar cipher' => decode_test(),
    'caesar cipher decoder'            => decode_test(),
    'shift cipher encrypter'           => decode_test(),
    'shift cipher decrypt'             => decode_test(),
    'how to decode caesar'             => undef,
);

done_testing;
