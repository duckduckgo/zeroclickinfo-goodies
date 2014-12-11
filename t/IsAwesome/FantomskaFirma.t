#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_fantomska_firma";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::IsAwesome::FantomskaFirma
    )],
    'duckduckhack FantomskaFirma' => test_zci('FantomskaFirma is hacking this search result!'),
    'duckduckhack GitHubUsername is awesome' => undef,
);

done_testing;
