#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'markdown_cheat';
zci is_cached   => 1;

sub test_success {
    return test_zci(
        qr/^$_[0]/s,
	    heading => 'Markdown Cheat Sheet',
		html => qr/Markdown:<pre>$_[0].*<\/pre>HTML:<pre>&lt;$_[1] ?.*&gt;.*<\/pre>/s,
    );
}

ddg_goodie_test(
	[ 'DDG::Goodie::MarkdownCheatSheet' ],
    'md header' => test_success('#', 'h1'),
    'markdown header' => test_success('#', 'h1'),
    'markdown cheat sheet header' => test_success('#', 'h1'),
    'md cheat sheet header' => test_success('#', 'h1'),
    'h1 markdown cheat sheet' => test_success('#', 'h1'),
    'markdown help h1' => test_success('#', 'h1'),
    'markdown syntax list' => test_success('-', 'ul'),
    'markdown quick reference em' => test_success('_', 'em'),
    'markdown guide strong' => test_success('\*\*', 'strong'),
    'markdown reference blockquote' => test_success('>', 'blockquote'),
    'markdown cheatsheet insert image' => test_success('!', 'img'),
    'markdown cheat sheet link' => test_success('\[', 'a'),
    'markdown cheat sheet random stuff' => undef,
);

done_testing;
