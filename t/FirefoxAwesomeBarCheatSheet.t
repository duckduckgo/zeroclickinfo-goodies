#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "firefox_awesome_bar_cheat_sheet";
zci is_cached   => 1;

my $test_zci = test_zci(
    qr/^Firefox Awesome Bar Shortcuts.*/s,
    
    heading => 'Firefox Awesome Bar Cheat Sheet',
    
    html => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,

);

ddg_goodie_test(
    [qw(
        DDG::Goodie::FirefoxAwesomeBarCheatSheet
    )],
    'firefox awesome bar cheatsheet'      => $test_zci,
    'firefox awesome bar cheat sheet'     => $test_zci,
    'firefox awesome bar help'            => $test_zci,
    'firefox awesome bar commands'        => $test_zci,
    'firefox awesome bar guide'           => $test_zci,
    'firefox awesome bar reference'       => $test_zci,
    'firefox awesome bar quick reference' => $test_zci,
);

done_testing;
