#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "ripemd";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::RIPEMD )],
    'RIPEMD this string' => test_zci(
        '33f65617195f9667673865edde5b96721d750046',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-160 hex hash',
            result    => '33f65617195f9667673865edde5b96721d750046'
        }
    ),
    'ripemdsum message ' => test_zci(
        '1dddbe1bea18cfda41f3fa4e6e66dbbbab93774e',
        structured_answer => {
            input     => ['message'],
            operation => 'RIPEMD-160 hex hash',
            result    => '1dddbe1bea18cfda41f3fa4e6e66dbbbab93774e'
        }
    ),
    'ripemd this string' => test_zci(
        '33f65617195f9667673865edde5b96721d750046',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-160 hex hash',
            result    => '33f65617195f9667673865edde5b96721d750046'
        }
    ),
    'ripemd base64 this string' => test_zci(
        'M/ZWFxlflmdnOGXt3luWch11AEY=',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-160 b64 hash',
            result    => 'M/ZWFxlflmdnOGXt3luWch11AEY='
        }
    ),
    'ripemd-128 this string' => test_zci(
        'bb5fe1c296fa5d94d1c9202511df16a7',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-128 hex hash',
            result    => 'bb5fe1c296fa5d94d1c9202511df16a7'
        }
    ),
    'ripemd-128 base64 this string' => test_zci(
        'u1/hwpb6XZTRySAlEd8Wpw==',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-128 b64 hash',
            result    => 'u1/hwpb6XZTRySAlEd8Wpw=='
        }
    ),
    'ripemd128 this string' => test_zci(
        'bb5fe1c296fa5d94d1c9202511df16a7',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-128 hex hash',
            result    => 'bb5fe1c296fa5d94d1c9202511df16a7'
        }
    ),
    'ripemd128sum this string' => test_zci(
        'bb5fe1c296fa5d94d1c9202511df16a7',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-128 hex hash',
            result    => 'bb5fe1c296fa5d94d1c9202511df16a7'
        }
    ),
    'ripemd128 "this string"' => test_zci(
        'bb5fe1c296fa5d94d1c9202511df16a7',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-128 hex hash',
            result    => 'bb5fe1c296fa5d94d1c9202511df16a7'
        }
    ),
    'ripemd128 hex this string' => test_zci(
        'bb5fe1c296fa5d94d1c9202511df16a7',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-128 hex hash',
            result    => 'bb5fe1c296fa5d94d1c9202511df16a7'
        }
    ),
    'ripemd128 "this and "that" string"' => test_zci(
        'f9d2f34b95e10b785745d6595a6d8292',
        structured_answer => {
            input     => ['this and &quot;that&quot; string'],
            operation => 'RIPEMD-128 hex hash',
            result    => 'f9d2f34b95e10b785745d6595a6d8292'
        }
    ),
    'ripemd128 hash of this string' => test_zci(
        'bb5fe1c296fa5d94d1c9202511df16a7',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-128 hex hash',
            result    => 'bb5fe1c296fa5d94d1c9202511df16a7'
        }
    ),
    'ripemd128 hash of string' => test_zci(
        '8f4b5ffc400e9fe83e33a2e0da3668b6',
        structured_answer => {
            input     => ['string'],
            operation => 'RIPEMD-128 hex hash',
            result    => '8f4b5ffc400e9fe83e33a2e0da3668b6'
        }
    ),
    'ripemd128 base64 hash of this string' => test_zci(
        'u1/hwpb6XZTRySAlEd8Wpw==',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-128 b64 hash',
            result    => 'u1/hwpb6XZTRySAlEd8Wpw=='
        }
    ),
    'ripemd128 <script>alert("ddg")</script>' => test_zci(
        'a595aa732b8f0b078f1ebe0860e248bf',
        structured_answer => {
            input     => ['&lt;script&gt;alert(&quot;ddg&quot;)&lt;/script&gt;'],
            operation => 'RIPEMD-128 hex hash',
            result    => 'a595aa732b8f0b078f1ebe0860e248bf'
        }
    ),
    'ripemd128 & / " \\\' ; < >' => test_zci(
        '34899b95c71c2d1b591f882bb04f2974',
        structured_answer => {
            input     => ['&amp; / &quot; \&#39; ; &lt; &gt;'],
            operation => 'RIPEMD-128 hex hash',
            result    => '34899b95c71c2d1b591f882bb04f2974'
        }
    ),
    'ripemd-160 this string' => test_zci(
        '33f65617195f9667673865edde5b96721d750046',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-160 hex hash',
            result    => '33f65617195f9667673865edde5b96721d750046'
        }
    ),
    'ripemd-160 base64 this string' => test_zci(
        'M/ZWFxlflmdnOGXt3luWch11AEY=',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-160 b64 hash',
            result    => 'M/ZWFxlflmdnOGXt3luWch11AEY='
        }
    ),
    'ripemd160 this string' => test_zci(
        '33f65617195f9667673865edde5b96721d750046',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-160 hex hash',
            result    => '33f65617195f9667673865edde5b96721d750046'
        }
    ),
    'ripemd160sum this string' => test_zci(
        '33f65617195f9667673865edde5b96721d750046',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-160 hex hash',
            result    => '33f65617195f9667673865edde5b96721d750046'
        }
    ),
    'ripemd160 "this string"' => test_zci(
        '33f65617195f9667673865edde5b96721d750046',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-160 hex hash',
            result    => '33f65617195f9667673865edde5b96721d750046'
        }
    ),
    'ripemd160 hex this string' => test_zci(
        '33f65617195f9667673865edde5b96721d750046',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-160 hex hash',
            result    => '33f65617195f9667673865edde5b96721d750046'
        }
    ),
    'ripemd160 "this and "that" string"' => test_zci(
        'ed53347ee8aeab1d994ffe7c2bdf117a05a25c3a',
        structured_answer => {
            input     => ['this and &quot;that&quot; string'],
            operation => 'RIPEMD-160 hex hash',
            result    => 'ed53347ee8aeab1d994ffe7c2bdf117a05a25c3a'
        }
    ),
    'ripemd160 hash of this string' => test_zci(
        '33f65617195f9667673865edde5b96721d750046',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-160 hex hash',
            result    => '33f65617195f9667673865edde5b96721d750046'
        }
    ),
    'ripemd160 base64 hash of this string' => test_zci(
        'M/ZWFxlflmdnOGXt3luWch11AEY=',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-160 b64 hash',
            result    => 'M/ZWFxlflmdnOGXt3luWch11AEY='
        }
    ),
    'ripemd160 <script>alert("ddg")</script>' => test_zci(
        '6d3217e6ae7111236ddedd6a866b0921bdd9eace',
        structured_answer => {
            input     => ['&lt;script&gt;alert(&quot;ddg&quot;)&lt;/script&gt;'],
            operation => 'RIPEMD-160 hex hash',
            result    => '6d3217e6ae7111236ddedd6a866b0921bdd9eace'
        }
    ),
    'ripemd160 & / " \\\' ; < >' => test_zci(
        'e32a3dc548d1b1dc57e1bea093ef1837734f91be',
        structured_answer => {
            input     => ['&amp; / &quot; \&#39; ; &lt; &gt;'],
            operation => 'RIPEMD-160 hex hash',
            result    => 'e32a3dc548d1b1dc57e1bea093ef1837734f91be'
        }
    ),
    'RIPEMD-256 that' => test_zci(
        '1ff3ee2a8109caf8d33f810cfb7dccaee71824bbb18c2ac65cbf6b175ffe57d1',
        structured_answer => {
            input     => ['that'],
            operation => 'RIPEMD-256 hex hash',
            result    => '1ff3ee2a8109caf8d33f810cfb7dccaee71824bbb18c2ac65cbf6b175ffe57d1'
        }
    ),
    'ripemd-256 this string' => test_zci(
        '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-256 hex hash',
            result    => '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40'
        }
    ),
    'ripemd-256 base64 this string' => test_zci(
        'NZK8DXZeQeiFVodXLP4Z9E2MGLvgzP3auciyYJheu0A=',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-256 b64 hash',
            result    => 'NZK8DXZeQeiFVodXLP4Z9E2MGLvgzP3auciyYJheu0A='
        }
    ),
    'ripemd256 this string' => test_zci(
        '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-256 hex hash',
            result    => '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40'
        }
    ),
    'ripemd256sum this string' => test_zci(
        '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-256 hex hash',
            result    => '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40'
        }
    ),
    'ripemd256 "this string"' => test_zci(
        '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-256 hex hash',
            result    => '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40'
        }
    ),
    'ripemd256 hex this string' => test_zci(
        '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-256 hex hash',
            result    => '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40'
        }
    ),
    'ripemd256 "this and "that" string"' => test_zci(
        '1dc63d877763fab85f9427c89f67a6a72a75851dada6a494ed99e0fb35bdd093',
        structured_answer => {
            input     => ['this and &quot;that&quot; string'],
            operation => 'RIPEMD-256 hex hash',
            result    => '1dc63d877763fab85f9427c89f67a6a72a75851dada6a494ed99e0fb35bdd093'
        }
    ),
    'ripemd256 hash of this string' => test_zci(
        '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-256 hex hash',
            result    => '3592bc0d765e41e8855687572cfe19f44d8c18bbe0ccfddab9c8b260985ebb40'
        }
    ),
    'ripemd256 base64 hash of this string' => test_zci(
        'NZK8DXZeQeiFVodXLP4Z9E2MGLvgzP3auciyYJheu0A=',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-256 b64 hash',
            result    => 'NZK8DXZeQeiFVodXLP4Z9E2MGLvgzP3auciyYJheu0A='
        }
    ),
    'ripemd256 <script>alert("ddg")</script>' => test_zci(
        'a59f78f4568226e051e8b4df12746d4d631120ee6ad5b375298affc48541bdcf',
        structured_answer => {
            input     => ['&lt;script&gt;alert(&quot;ddg&quot;)&lt;/script&gt;'],
            operation => 'RIPEMD-256 hex hash',
            result    => 'a59f78f4568226e051e8b4df12746d4d631120ee6ad5b375298affc48541bdcf'
        }
    ),
    'ripemd256 & / " \\\' ; < >' => test_zci(
        'cc93c15f26ea7ba2827f99340204b7d32ddd2ac3ad3256731a6c04882fb6da4d',
        structured_answer => {
            input     => ['&amp; / &quot; \&#39; ; &lt; &gt;'],
            operation => 'RIPEMD-256 hex hash',
            result    => 'cc93c15f26ea7ba2827f99340204b7d32ddd2ac3ad3256731a6c04882fb6da4d'
        }
    ),
    'ripemd-320 this string' => test_zci(
        '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-320 hex hash',
            result    => '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6'
        }
    ),
    'ripemd-320 base64 this string' => test_zci(
        'kJjAFD50qWEB3ahN9B37nviebmHV25ktd/7mNVEoWayEsNa+evLW5g==',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-320 b64 hash',
            result    => 'kJjAFD50qWEB3ahN9B37nviebmHV25ktd/7mNVEoWayEsNa+evLW5g=='
        }
    ),
    'ripemd320 this string' => test_zci(
        '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-320 hex hash',
            result    => '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6'
        }
    ),
    'ripemd320 secret' => test_zci(
        'c93e9064381bb8ca9a2d5436b872cce22a7beb78c3ba971906011096cce68359762bb53c08925dc7',
        structured_answer => {
            input     => ['secret'],
            operation => 'RIPEMD-320 hex hash',
            result    => 'c93e9064381bb8ca9a2d5436b872cce22a7beb78c3ba971906011096cce68359762bb53c08925dc7'
        }
    ),
    'ripemd320sum this string' => test_zci(
        '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-320 hex hash',
            result    => '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6'
        }
    ),
    'ripemd320 "this string"' => test_zci(
        '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-320 hex hash',
            result    => '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6'
        }
    ),
    'ripemd320 hex this string' => test_zci(
        '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-320 hex hash',
            result    => '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6'
        }
    ),
    'ripemd320 "this and "that" string"' => test_zci(
        '6605365efa91d0739419f8bd061d126fa53bed938e1958dd193cf1156f24dd55984897b88fd3eb26',
        structured_answer => {
            input     => ['this and &quot;that&quot; string'],
            operation => 'RIPEMD-320 hex hash',
            result    => '6605365efa91d0739419f8bd061d126fa53bed938e1958dd193cf1156f24dd55984897b88fd3eb26'
        }
    ),
    'ripemd320 hash of this string' => test_zci(
        '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-320 hex hash',
            result    => '9098c0143e74a96101dda84df41dfb9ef89e6e61d5db992d77fee635512859ac84b0d6be7af2d6e6'
        }
    ),
    'ripemd320 base64 hash of this string' => test_zci(
        'kJjAFD50qWEB3ahN9B37nviebmHV25ktd/7mNVEoWayEsNa+evLW5g==',
        structured_answer => {
            input     => ['this string'],
            operation => 'RIPEMD-320 b64 hash',
            result    => 'kJjAFD50qWEB3ahN9B37nviebmHV25ktd/7mNVEoWayEsNa+evLW5g=='
        }
    ),
    'ripemd320 <script>alert("ddg")</script>' => test_zci(
        '371aece9feb936b50e9e7a07186203c0c363d085a5aa307ae04b3bf1d678413e6b034e1a88a2e948',
        structured_answer => {
            input     => ['&lt;script&gt;alert(&quot;ddg&quot;)&lt;/script&gt;'],
            operation => 'RIPEMD-320 hex hash',
            result    => '371aece9feb936b50e9e7a07186203c0c363d085a5aa307ae04b3bf1d678413e6b034e1a88a2e948'
        }
    ),
    'ripemd320 & / " \\\' ; < >' => test_zci(
        '1049653078fea2c686104216907571b7aad4ca57eba23d515c5dd8c43aa06ec112554ec4664c0e35',
        structured_answer => {
            input     => ['&amp; / &quot; \&#39; ; &lt; &gt;'],
            operation => 'RIPEMD-320 hex hash',
            result    => '1049653078fea2c686104216907571b7aad4ca57eba23d515c5dd8c43aa06ec112554ec4664c0e35'
        }
    ),
    'ripemd512 this string' => undef,
);

done_testing;

