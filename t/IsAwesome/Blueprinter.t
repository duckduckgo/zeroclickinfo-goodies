#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_blueprinter";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::GitHubUsername
    )],
    'duckduckhack GitHubUsername' => test_zci('GitHubUsername is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack GitHubUsername is awesome' => undef,
);

done_testing;
