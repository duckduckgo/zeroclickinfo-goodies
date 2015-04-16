#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_git_hub_username";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::QuoidautreGitHubUsername
    )],
    'duckduckhack QuoidautreGitHubUsername' => test_zci('QuoidautreGitHubUsername is awesome and has successfully completed the DuckDuckHack Goodie tutorial!'),
    'duckduckhack QuoidautreGitHubUsername is awesome' => undef,
);

done_testing;