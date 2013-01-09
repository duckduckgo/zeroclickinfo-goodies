#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Gravatar
        )],
        'gravatar user@example.com' => 
            test_zci("https://secure.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af?d=mm&s=100",
                     html => "<img src='https://secure.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af?d=mm&s=100' />"),
        'ascii john@example.net' => 
            test_zci("https://secure.gravatar.com/avatar/8a0682897dde754b2040abcc7bf3edc1?d=mm&s=100",
                     html => "<img src='https://secure.gravatar.com/avatar/8a0682897dde754b2040abcc7bf3edc1?d=mm&s=100' />"),
);

done_testing;

