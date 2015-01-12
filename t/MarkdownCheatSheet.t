#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'markdown_cheat';
zci is_cached   => 1;

sub test_success {
    return test_zci(
        qr/^<$_[0] ?.*>.*<\/\w*><pre>.*<\/pre>/s,
	    heading => 'Markdown Cheat Sheet',
		html => qr/^<$_[0] ?.*>.*<\/\w*><pre>.*<\/pre>/s,
    );
}

ddg_goodie_test(
	[ 'DDG::Goodie::MarkdownCheatSheet' ],
    'markdown cheat sheet header' => test_success('h1'),
    'markdown cheat sheet h1' => test_success('h1'),
    'markdown cheat sheet list' => test_success('ul'),
    'markdown cheat sheet em' => test_success('em'),
    'markdown cheat sheet strong' => test_success('strong'),
    'markdown cheat sheet blockquote' => test_success('blockquote'),
    'markdown cheat sheet insert image' => test_success('img'),
    'markdown cheat sheet link' => test_success('a'),
    'markdown cheat sheet random stuff' => undef,
);

done_testing;
