#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "cheat_sheet_cheat_sheet";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::CheatSheetCheatSheet )],
    'duckduckgo cheat sheets' => test_zci(
        qr/CronTab/s,
        html => qr/<p>/s,
        heading => "Cheat sheets on DuckDuckGo"),
    'ddg cheat sheets' => test_zci(
        qr/CronTab/s,
        html => qr/<p>/s,
        heading => "Cheat sheets on DuckDuckGo"),
    'cheat sheet' => undef,
);

done_testing;
