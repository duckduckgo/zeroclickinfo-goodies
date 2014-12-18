#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'aspect_ratio';
zci is_cached => 1;

ddg_goodie_test([qw(
          DDG::Goodie::AspectRatio
          )
    ],
    'aspect ratio 4:3 640:?' => test_zci(
        'Aspect ratio: 640:480 (4:3)',
        structured_answer => {
            input     => ['4:3'],
            operation => 'aspect ratio',
            result    => '640:480'
        }
    ),
    'aspect ratio 4:3 ?:480' => test_zci(
        'Aspect ratio: 640:480 (4:3)',
        structured_answer => {
            input     => ['4:3'],
            operation => 'aspect ratio',
            result    => '640:480'
        }
    ),
    'aspect ratio 1:1.5 20:?' => test_zci(
        'Aspect ratio: 20:30 (1:1.5)',
        structured_answer => {
            input     => ['1:1.5'],
            operation => 'aspect ratio',
            result    => '20:30'
        }
    ),
    'aspect ratio 1:1.5 ?:15' => test_zci(
        'Aspect ratio: 10:15 (1:1.5)',
        structured_answer => {
            input     => ['1:1.5'],
            operation => 'aspect ratio',
            result    => '10:15'
        }
    ),
);

done_testing;
