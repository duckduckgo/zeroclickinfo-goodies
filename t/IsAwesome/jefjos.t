#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_jefjos";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::jefjos
    )],
    'duckduckhack jefjos' => test_zci('Jefjos is awesome!'),
    'duckduckhack GitHubUsername is awesome' => undef,
);

done_testing;
