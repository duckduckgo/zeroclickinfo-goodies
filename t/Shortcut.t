#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'shortcut';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Shortcut
        )],
        'undo keyboard shortcut' => test_zci('Ctrl+Z'),
        'ctrl c shortcut' => test_zci('Copy'),
        'F6 shortcut' => test_zci('Address Bar'),
        'location bar shortcut' => test_zci('Ctrl+L'),
);

done_testing;
