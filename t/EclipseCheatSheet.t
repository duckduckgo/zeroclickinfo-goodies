#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "eclipse_cheat_sheet";
zci is_cached   => 1;

# this goodie always returns the same answer whenever it's triggered
my $test_zci = test_zci(
    qr/^Editor Navigation.*Search and Replace.*Indentions and Comments.*Refactoring.*Select Text.*Edit Text.*Run and Debug.*Code Information.*/s,
    
    heading => 'Eclipse Cheat Sheet',

    html => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,
);

ddg_goodie_test(
    [qw(DDG::Goodie::EclipseCheatSheet)],
    'eclipse cheatsheet'      => $test_zci,
    'eclipse cheat sheet'     => $test_zci,
    'eclipse help'            => $test_zci,
    'eclipse commands'        => $test_zci,
    'eclipse guide'           => $test_zci,
    'eclipse reference'       => $test_zci,
    'eclipse quick reference' => $test_zci,
    'eclipse shortcuts'       => $test_zci,
    'eclipse shortcut'        => $test_zci,
);

done_testing;
