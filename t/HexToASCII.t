#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'ascii';
zci is_cached   => 1;

sub build_structured_answer {
    my ($word, $response) = @_;
    return $response,
        structured_answer => {
            data => {
                title    => $response,
                subtitle => "Hex to ASCII: $word",
            },
            templates => {
                group => 'text',
            },
        },
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::HexToASCII )],
    'ascii 0x7465ff7374'      => undef,
    'ascii 0x7465007374'      => build_test('0x7465007374', 'te<code title="null">[NUL]</code>st'),
    'ascii 0x74657374'        => build_test('0x74657374', 'test'),
    '0x74657374 hex to ascii' => build_test('0x74657374', 'test'),
    '0x74657374 to ascii'     => build_test('0x74657374', 'test'),
    'ascii 0x5468697320697320612074657374' => build_test('0x5468697320697320612074657374', 'This is a test'),
    'ascii 0x466f7220736f6d6520726561736f6e2c2049206465636964656420746f2061736b20612073656172636820656e67696e6520746f20636f6e766572742068657820746f2041534349492e0d0a436f6f6c2c20746869732073656172636820656e67696e6520646f65732069742c20756e74696c20492072756e206f7574206f662073706163652e' => build_test('0x466f7220736f6d6520726561736f6e2c2049206465636964656420746f2061736b20612073656172636820656e67696e6520746f20636f6e766572742068657820746f2041534349492e0d0a436f6f6c2c20746869732073656172636820656e67696e6520646f65732069742c20756e74696c20492072756e206f7574206f662073706163652e', 'For some reason, I decided to ask a search engine to convert hex to ASCII.<code title="carriage return">[CR]</code><code title="linefeed">[LF]</code>Cool, this search engine does it, until I run out of &hellip;'),
);

done_testing;
