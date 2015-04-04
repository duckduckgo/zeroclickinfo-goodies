#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "cheat_sheet_cheat_sheet";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::CheatSheetCheatSheet )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'duckduckgo cheat sheets' => test_zci(
        qr/CronTab/s,
        html => qr/<p>/s,
        heading => "Cheat sheets on DuckDuckGo"),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'bad example query' => undef,
);

done_testing;
