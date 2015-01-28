#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "ddg_shortcuts";
zci is_cached   => 1;

# This goodie always returns the same answer whenever its triggered
my $test_zci = test_zci(
    qr/^Open results.*Move around.*/s,
    heading => 'DuckDuckGo Shortcuts Cheat Sheet',
    html => qr#<div(.*<table class="ddg_shortcuts-table".*<tr.*<td.*</table.*)+</div>$#s,
);

ddg_goodie_test(
    [qw( DDG::Goodie::DdgShortcuts )],
    
    'duck duck go cheatsheet'                        => $test_zci, # Generated triggers - start
    'duck duck go cheat sheet'                       => $test_zci,
    'duck duck go keyboard shortcuts'                => $test_zci,
    'duck duck go shortcuts'                         => $test_zci,
    'duck duck go shortcuts cheatsheet'              => $test_zci,
    'duck duck go shortcuts cheat sheet'             => $test_zci,
    'duck duck go\'s cheatsheet'                     => $test_zci,
    'duck duck go\'s cheat sheet'                    => $test_zci,
    'duck duck go\'s keyboard shortcuts'             => $test_zci,
    'duck duck go\'s shortcuts'                      => $test_zci,
    'duck duck go\'s shortcuts cheatsheet'           => $test_zci,
    'duck duck go\'s shortcuts cheat sheet'          => $test_zci,
    'duck duck gos cheatsheet'                       => $test_zci,
    'duck duck gos cheat sheet'                      => $test_zci,
    'duck duck gos keyboard shortcuts'               => $test_zci,
    'duck duck gos shortcuts'                        => $test_zci,
    'duck duck gos shortcuts cheatsheet'             => $test_zci,
    'duck duck gos shortcuts cheat sheet'            => $test_zci,
    'duckduck go cheatsheet'                         => $test_zci,
    'duckduck go cheat sheet'                        => $test_zci,
    'duckduck go keyboard shortcuts'                 => $test_zci,
    'duckduck go shortcuts'                          => $test_zci,
    'duckduck go shortcuts cheatsheet'               => $test_zci,
    'duckduck go shortcuts cheat sheet'              => $test_zci,
    'duckduck go\'s cheatsheet'                      => $test_zci,
    'duckduck go\'s cheat sheet'                     => $test_zci,
    'duckduck go\'s keyboard shortcuts'              => $test_zci,
    'duckduck go\'s shortcuts'                       => $test_zci,
    'duckduck go\'s shortcuts cheatsheet'            => $test_zci,
    'duckduck go\'s shortcuts cheat sheet'           => $test_zci,
    'duckduck gos cheatsheet'                        => $test_zci,
    'duckduck gos cheat sheet'                       => $test_zci,
    'duckduck gos keyboard shortcuts'                => $test_zci,
    'duckduck gos shortcuts'                         => $test_zci,
    'duckduck gos shortcuts cheatsheet'              => $test_zci,
    'duckduck gos shortcuts cheat sheet'             => $test_zci,
    'duck duckgo cheatsheet'                         => $test_zci,
    'duck duckgo cheat sheet'                        => $test_zci,
    'duck duckgo keyboard shortcuts'                 => $test_zci,
    'duck duckgo shortcuts'                          => $test_zci,
    'duck duckgo shortcuts cheatsheet'               => $test_zci,
    'duck duckgo shortcuts cheat sheet'              => $test_zci,
    'duck duckgo\'s cheatsheet'                      => $test_zci,
    'duck duckgo\'s cheat sheet'                     => $test_zci,
    'duck duckgo\'s keyboard shortcuts'              => $test_zci,
    'duck duckgo\'s shortcuts'                       => $test_zci,
    'duck duckgo\'s shortcuts cheatsheet'            => $test_zci,
    'duck duckgo\'s shortcuts cheat sheet'           => $test_zci,
    'duck duckgos cheatsheet'                        => $test_zci,
    'duck duckgos cheat sheet'                       => $test_zci,
    'duck duckgos keyboard shortcuts'                => $test_zci,
    'duck duckgos shortcuts'                         => $test_zci,
    'duck duckgos shortcuts cheatsheet'              => $test_zci,
    'duck duckgos shortcuts cheat sheet'             => $test_zci,
    'duckduckgo cheatsheet'                          => $test_zci,
    'duckduckgo cheat sheet'                         => $test_zci,
    'duckduckgo keyboard shortcuts'                  => $test_zci,
    'duckduckgo shortcuts'                           => $test_zci,
    'duckduckgo shortcuts cheatsheet'                => $test_zci,
    'duckduckgo shortcuts cheat sheet'               => $test_zci,
    'duckduckgo\'s cheatsheet'                       => $test_zci,
    'duckduckgo\'s cheat sheet'                      => $test_zci,
    'duckduckgo\'s keyboard shortcuts'               => $test_zci,
    'duckduckgo\'s shortcuts'                        => $test_zci,
    'duckduckgo\'s shortcuts cheatsheet'             => $test_zci,
    'duckduckgo\'s shortcuts cheat sheet'            => $test_zci,
    'duckduckgos cheatsheet'                         => $test_zci,
    'duckduckgos cheat sheet'                        => $test_zci,
    'duckduckgos keyboard shortcuts'                 => $test_zci,
    'duckduckgos shortcuts'                          => $test_zci,
    'duckduckgos shortcuts cheatsheet'               => $test_zci,
    'duckduckgos shortcuts cheat sheet'              => $test_zci,
    'ddg cheatsheet'                                 => $test_zci,
    'ddg cheat sheet'                                => $test_zci,
    'ddg keyboard shortcuts'                         => $test_zci,
    'ddg shortcuts'                                  => $test_zci,
    'ddg shortcuts cheatsheet'                       => $test_zci,
    'ddg shortcuts cheat sheet'                      => $test_zci,
    'ddg\'s cheatsheet'                              => $test_zci,
    'ddg\'s cheat sheet'                             => $test_zci,
    'ddg\'s keyboard shortcuts'                      => $test_zci,
    'ddg\'s shortcuts'                               => $test_zci,
    'ddg\'s shortcuts cheatsheet'                    => $test_zci,
    'ddg\'s shortcuts cheat sheet'                   => $test_zci,
    'ddgs cheatsheet'                                => $test_zci,
    'ddgs cheat sheet'                               => $test_zci,
    'ddgs keyboard shortcuts'                        => $test_zci,
    'ddgs shortcuts'                                 => $test_zci,
    'ddgs shortcuts cheatsheet'                      => $test_zci, # Generated triggers - end
    
    'DDGs Shortcuts Cheat Sheet'                     => $test_zci, # Upper case triggers
    'ddgs shortcuts cheat sheet WHATEVER AFTER'      => $test_zci, # starting trigger
    'WHATEVER BEFORE ddgs shortcuts cheat sheet'     => $test_zci, # ending trigger
    'ddgs shortcuts WHATEVER HERE cheat sheet'       => $test_zci, # triggers on "ddgs shortcuts"
    
    'ddgs WHATEVER IN BETWEEN shortcuts cheat sheet' => undef, # no complete trigger
    'BEFORE ddgs shortcuts cheat sheet AND AFTER'    => undef, # no start/end trigger
    'DUCKDUCKGO ddg shortcuts cheat sheet AFTER'     => undef, # no start/end trigger
    'ddgs shortcut cheat sheet'                      => undef, # misspelled trigger
);

done_testing;
