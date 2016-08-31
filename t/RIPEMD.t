#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "ripemd";
zci is_cached   => 1;

sub build_test {
    my ($answer, $input, $operation) = @_;
    return test_zci($answer, structured_answer => {
        data => {
            title => $answer,
            subtitle => "$operation: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::RIPEMD )],
    'RIPEMD this string' => build_test('33f65617195f9667673865edde5b96721d750046', 'this string', 'RIPEMD-160 hex hash'),
    'ripemdsum message ' => build_test('1dddbe1bea18cfda41f3fa4e6e66dbbbab93774e', 'message', 'RIPEMD-160 hex hash'),
    'ripemd this string' => build_test('33f65617195f9667673865edde5b96721d750046', 'this string','RIPEMD-160 hex hash'),
    'ripemd base64 this string' => build_test('M/ZWFxlflmdnOGXt3luWch11AEY=', 'this string', 'RIPEMD-160 b64 hash'),
    'ripemd-128 this string' => build_test('bb5fe1c296fa5d94d1c9202511df16a7', 'this string', 'RIPEMD-128 hex hash'),
    'ripemd-128 base64 this string' => build_test('u1/hwpb6XZTRySAlEd8Wpw==', 'this string', 'RIPEMD-128 b64 hash'),
    'ripemd128 this string' => build_test('bb5fe1c296fa5d94d1c9202511df16a7', 'this string', 'RIPEMD-128 hex hash'),
    'ripemd128sum this string' => build_test('bb5fe1c296fa5d94d1c9202511df16a7', 'this string', 'RIPEMD-128 hex hash'),
    'ripemd128 "this string"' => build_test('bb5fe1c296fa5d94d1c9202511df16a7', 'this string', 'RIPEMD-128 hex hash'),
    'ripemd128 hex this string' => build_test('bb5fe1c296fa5d94d1c9202511df16a7', 'this string', 'RIPEMD-128 hex hash'),
    'ripemd128 "this and "that" string"' => build_test('f9d2f34b95e10b785745d6595a6d8292', 'this and "that" string', 'RIPEMD-128 hex hash'),
    'ripemd128 hash of this string' => build_test('bb5fe1c296fa5d94d1c9202511df16a7', 'this string', 'RIPEMD-128 hex hash'),
    'ripemd128 hash of string' => build_test('8f4b5ffc400e9fe83e33a2e0da3668b6', 'string', 'RIPEMD-128 hex hash'),
    'ripemd128 base64 hash of this string' => build_test('u1/hwpb6XZTRySAlEd8Wpw==', 'this string', 'RIPEMD-128 b64 hash'),
    'ripemd128 <script>alert("ddg")</script>' => build_test('a595aa732b8f0b078f1ebe0860e248bf', '<script>alert("ddg")</script>', 'RIPEMD-128 hex hash'),
    q|ripemd128 & / " \\' ; < >| => build_test('34899b95c71c2d1b591f882bb04f2974', "& / \" \\' ; < >", 'RIPEMD-128 hex hash'),
    'ripemd-160 this string' => build_test('33f65617195f9667673865edde5b96721d750046', 'this string', 'RIPEMD-160 hex hash',),
    'ripemd-160 base64 this string' => build_test('M/ZWFxlflmdnOGXt3luWch11AEY=', 'this string', 'RIPEMD-160 b64 hash'),
    'ripemd160 this string' => build_test('33f65617195f9667673865edde5b96721d750046', 'this string', 'RIPEMD-160 hex hash'),
    'ripemd160sum this string' => build_test('33f65617195f9667673865edde5b96721d750046', 'this string', 'RIPEMD-160 hex hash'),
    'ripemd160 "this string"' => build_test('33f65617195f9667673865edde5b96721d750046', 'this string', 'RIPEMD-160 hex hash'),
    'ripemd160 hex this string' => build_test('33f65617195f9667673865edde5b96721d750046', 'this string', 'RIPEMD-160 hex hash'),
    'ripemd160 "this and "that" string"' => build_test('ed53347ee8aeab1d994ffe7c2bdf117a05a25c3a', 'this and "that" string', 'RIPEMD-160 hex hash'),
    'ripemd160 hash of this string' => build_test('33f65617195f9667673865edde5b96721d750046', 'this string', 'RIPEMD-160 hex hash'),
    'ripemd160 base64 hash of this string' => build_test('M/ZWFxlflmdnOGXt3luWch11AEY=', 'this string', 'RIPEMD-160 b64 hash'),
    'ripemd160 <script>alert("ddg")</script>' => build_test('6d3217e6ae7111236ddedd6a866b0921bdd9eace', '<script>alert("ddg")</script>', 'RIPEMD-160 hex hash'),
    q|ripemd160 & / " \\' ; < >| => build_test('e32a3dc548d1b1dc57e1bea093ef1837734f91be', "& / \" \\' ; < >", 'RIPEMD-160 hex hash'),
    'RIPEMD-256 that' => build_test('1ff3ee2a8109caf8d33f810cfb7dccaee71824bbb18c2ac65cbf6b175ffe57d1', 'that', 'RIPEMD-256 hex hash'),
    'ripemd-256 this string' => build_test('3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40', 'this string', 'RIPEMD-256 hex hash'),
    'ripemd-256 base64 this string' => build_test('NZK8DXZeQeiFVodXLP4Z9E2MGLvgzP3auciyYJheu0A=', 'this string', 'RIPEMD-256 b64 hash'),
    'ripemd256 this string' => build_test('3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40', 'this string', 'RIPEMD-256 hex hash'),
    'ripemd256sum this string' => build_test('3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40', 'this string', 'RIPEMD-256 hex hash'),
    'ripemd256 "this string"' => build_test('3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40', 'this string', 'RIPEMD-256 hex hash'),
    'ripemd256 hex this string' => build_test('3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40', 'this string', 'RIPEMD-256 hex hash'),
    'ripemd256 "this and "that" string"' => build_test('1dc63d877763fab85f9427c89f67a6a72a75851dada6a494ed99e0fb35bdd093', 'this and "that" string', 'RIPEMD-256 hex hash'),
    'ripemd256 hash of this string' => build_test('3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40', 'this string', 'RIPEMD-256 hex hash'),
    'ripemd256 base64 hash of this string' => build_test('NZK8DXZeQeiFVodXLP4Z9E2MGLvgzP3auciyYJheu0A=', 'this string', 'RIPEMD-256 b64 hash'),
    'ripemd256 <script>alert("ddg")</script>' => build_test('a59f78f4568226e051e8b4df12746d4d631120ee6ad5b375298affc48541bdcf', '<script>alert("ddg")</script>', 'RIPEMD-256 hex hash'),
    q|ripemd256 & / " \\' ; < >| => build_test('cc93c15f26ea7ba2827f99340204b7d32ddd2ac3ad3256731a6c04882fb6da4d', "& / \" \\' ; < >", 'RIPEMD-256 hex hash'),
    'ripemd-320 this string' => build_test('9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6', 'this string', 'RIPEMD-320 hex hash'),
    'ripemd-320 base64 this string' => build_test('kJjAFD50qWEB3ahN9B37nviebmHV25ktd/7mNVEoWayEsNa+evLW5g==', 'this string', 'RIPEMD-320 b64 hash'),
    'ripemd320 this string' => build_test('9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6', 'this string', 'RIPEMD-320 hex hash'),
    'ripemd320 secret' => build_test('c93e9064381bb8ca9a2d5436b872cce22a7beb78c3ba971906011096cce68359762bb53c08925dc7', 'secret', 'RIPEMD-320 hex hash'),
    'ripemd320sum this string' => build_test('9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6', 'this string', 'RIPEMD-320 hex hash'),
    'ripemd320 "this string"' => build_test('9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6', 'this string', 'RIPEMD-320 hex hash'),
    'ripemd320 hex this string' => build_test('9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6', 'this string', 'RIPEMD-320 hex hash'),
    'ripemd320 "this and "that" string"' => build_test('6605365efa91d0739419f8bd061d126fa53bed938e1958dd193cf1156f24dd55984897b88fd3eb26', 'this and "that" string', 'RIPEMD-320 hex hash'),
    'ripemd320 hash of this string' => build_test('9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6', 'this string', 'RIPEMD-320 hex hash'),
    'ripemd320 base64 hash of this string' => build_test('kJjAFD50qWEB3ahN9B37nviebmHV25ktd/7mNVEoWayEsNa+evLW5g==', 'this string', 'RIPEMD-320 b64 hash'),
    'ripemd320 <script>alert("ddg")</script>' => build_test('371aece9feb936b50e9e7a07186203c0c363d085a5aa307ae04b3bf1d678413e6b034e1a88a2e948', '<script>alert("ddg")</script>', 'RIPEMD-320 hex hash'),
    q|ripemd320 & / " \\' ; < >| => build_test('1049653078fea2c686104216907571b7aad4ca57eba23d515c5dd8c43aa06ec112554ec4664c0e35', "& / \" \\' ; < >", 'RIPEMD-320 hex hash'),
    'ripemd512 this string' => undef,
);

done_testing;
