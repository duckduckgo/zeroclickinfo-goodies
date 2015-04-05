#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_git_hubrramyr";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::GitHubrramyr
    )],
    'duckduckhack GitHubrramyr' => test_zci('GitHubrramyr is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack GitHubrramyr is awesome' => undef,
);

done_testing;
