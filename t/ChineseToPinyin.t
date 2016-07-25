#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "chinese_to_pinyin";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::ChineseToPinyin )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'pinyin 你好' => test_zci(
        "Pinyin of 你好 is \"nǐ hǎo\"",
        structured_answer => {
            data => {
                title    => "nǐ hǎo",
                subtitle => "Pinyin of 你好",
            },
            templates => {
                group => "text",
            }
        }
    ),
    'pinyin 女生' => test_zci(
        "Pinyin of 女生 is \"nǚ shēng\"",
        structured_answer => {
            data => {
                title    => "nǚ shēng",
                subtitle => "Pinyin of 女生",
            },
            templates => {
                group => "text",
            }
        }
    ),
    'pinyin lai2 zi4 zhong1 guo2' => test_zci(
        "Pinyin of lai2 zi4 zhong1 guo2 is \"lái zì zhōng guó\"",
        structured_answer => {
            data => {
                title    => "lái zì zhōng guó",
                subtitle => "Pinyin of lai2 zi4 zhong1 guo2",
            },
            templates => {
                group => "text",
            }
        }
    ),
    'PINYIN PENG2 YOU3' => test_zci(
        "Pinyin of peng2 you3 is \"péng yǒu\"",
        structured_answer => {
            data => {
                title    => "péng yǒu",
                subtitle => "Pinyin of peng2 you3",
            },
            templates => {
                group => "text",
            }
        }
    ),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'pinyin ' => undef,
    'pinyin yes3' => undef,
    'pinyin how are you?' => undef,
    'pinyin zhōng guó' => undef,
);

done_testing;