#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'regex_cheat';
zci is_cached   => 1;

ddg_goodie_test(
    [
        # This is the name of the goodie that will be loaded to test.
        'DDG::Goodie::RegexCheatSheet'
    ],
    # this one is really hard to actually test, so fudge it
    'regex' => test_zci(
        qr/^Anchors.*|((Character|POSIX) Classes).*Pattern Modifiers.*Escape Sequences.*Groups and Ranges.*Assertions.*Special Characters.*String Replacement/s,
        html => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,
        heading => 'Regex Cheat Sheet',
    ),
    'regex ^' => test_zci(
        "^ - Start of string or line",
        html => "<code>^</code> - Start of string or line",
        heading => 'Regex Cheat Sheet',
    ),
    'regex $' => test_zci(
        '$ - End of string or line',
        html => '<code>$</code> - End of string or line',
        heading => 'Regex Cheat Sheet',
    ),
    'regexp \s' => test_zci(
        '\s - Whitespace',
        html => '<code>\s</code> - Whitespace',
        heading => 'Regex Cheat Sheet',
    ),
    'regular expression [a-e]' => test_zci(
        '[a-e] - Single character range (a or b ... or e)',
        html => '<code>[a-e]</code> - Single character range (a or b ... or e)',
        heading => 'Regex Cheat Sheet',
    ),
    'regular expression [M-Y]' => test_zci(
        '[M-Y] - Single character range (M or N ... or Y)',
        html => '<code>[M-Y]</code> - Single character range (M or N ... or Y)',
        heading => 'Regex Cheat Sheet',
    ),
    'regex [3-5]' => test_zci(
        '[3-5] - Single character range (3 or 4 or 5)',
        html => '<code>[3-5]</code> - Single character range (3 or 4 or 5)',
        heading => 'Regex Cheat Sheet',
    ),
    'regex [1-2]' => test_zci(
        '[1-2] - Single character range (1 or 2)',
        html => '<code>[1-2]</code> - Single character range (1 or 2)',
        heading => 'Regex Cheat Sheet',
    ),
    'regexp $' => test_zci(
        '$ - End of string or line',
        html => '<code>$</code> - End of string or line',
        heading => 'Regex Cheat Sheet'
    ),
    'regex [b-X]' => undef,
    'regex [a-Z]' => undef,
    'regex [Y-E]' => undef,
    'regex [A-a]' => undef,
    'regex [z-a]' => undef,
    'regex [a-1]' => undef,
    'regex [1-a]' => undef,
    'regex [1-1]' => undef,
    'regex [3-2]' => undef,
    'regex [a-]' => undef,
    'regex [4-8] fo sho!' => undef,
    'regex foop [1-3]' => undef,
);

done_testing;
