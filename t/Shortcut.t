#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'shortcut';
zci is_cached   => 1;

my $start = 'The shortcut for ';
my $first = 'Show desktop in Windows is ⊞Win+D or ⊞Win+M (then use ⊞Win+⇧Shift+M to bring back all windows)';
my $second = 'New folder in KDE/GNOME is Ctrl+⇧Shift+N';
my $third = 'Redo in Mac OS is ⇧Shift+⌘Cmd+Z';
my $fourth = 'Paste special in KDE/GNOME is Ctrl+⇧Shift+V';
my $br = ' <br/>';
my $link = '<a href="https://en.wikipedia.org/wiki/Table_of_keyboard_shortcuts">More at Wikipedia</a>';

ddg_goodie_test(
        [qw(    DDG::Goodie::Shortcut
        )],
        'windows show desktop shortcut' => test_zci($start . $first,  html => $start . $first  . $br . $link),
        'ubuntu shortcut new folder'    => test_zci($start . $second, html => $start . $second . $br . $link),
        'redo shortcut mac'             => test_zci($start . $third,  html => $start . $third  . $br . $link),
        'paste special shortcut'        => undef #test_zci($start . $fourth, html => $start . $fourth . $br . $link)
);

done_testing;
