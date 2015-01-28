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
    'shortcuts'                  => $test_zci,
    'shortcuts cheat sheet'      => $test_zci,
    'cheatsheet shortcuts'       => $test_zci,
    '  keyboard shortcuts'       => $test_zci,
    'duckduckgo\'s shortcuts'    => $test_zci,
    'ddg keyboard shortcuts  '   => $test_zci,
    'ddgs shortcuts cheat sheet' => $test_zci,
    'duck duck go \'s shortcuts' => $test_zci,
    'cheat shortcuts sheet  '    => $test_zci, # actually works as "shortcuts" is removed
    ''                           => undef, # no "shortcuts"
    'ddg keyboard'               => undef, # no "shortcuts"
    'duckduckgo shortcut'        => undef, # no "shortcuts"
    'shortcuts cheat ddg sheet'  => undef, # sthg between "cheat" and "sheet"
    'shortcuts whatever'         => undef, # a non-allowed word
    'short cuts'                 => undef, # no "shortcuts"
);

done_testing;
