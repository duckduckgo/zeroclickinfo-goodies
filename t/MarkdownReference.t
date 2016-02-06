#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'markdown_reference';
zci is_cached   => 1;

sub build_structured_answer {
    my ($result_type, $formatted_input) = shift;
    return $result_type,
        structured_answer => {
            id   => 'markdown_reference',
            name => 'Answer',
            data => {
                element_type => $result_type,
                subtitle     => $formatted_input,
            },
            templates => {
                group   => 'text',
                content => 'DDH.markdown_reference.content',
            },
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
	[ 'DDG::Goodie::MarkdownReference' ],
	  # Headers
    'md header'                   => build_test('header', 'Markdown Headers'),
    'markdown header'             => build_test('header', 'Markdown Headers'),
    'markdown cheat sheet header' => build_test('header', 'Markdown Headers'),
    'md cheat sheet header'       => build_test('header', 'Markdown Headers'),
    'h1 markdown cheat sheet'     => build_test('header', 'Markdown Headers'),
    'markdown help h1'            => build_test('header', 'Markdown Headers'),
    # Lists
    'markdown syntax list' => build_test('list', 'Markdown Lists'),
    # Emphasis
    'markdown quick reference em' => build_test('emphasis', 'Markdown Emphasis'),
    # Bold
    'markdown guide strong' => build_test('bold', 'Markdown Bold'),
    # Block Quote
    'markdown reference blockquote' => build_test('blockquote', 'Markdown Block Quote'),
    # Image
    'markdown cheatsheet insert image' => build_test('image', 'Markdown Images'),
    # Links
    'markdown cheat sheet link' => build_test('link', 'Markdown Links'),
    # Should not trigger
    'markdown cheat sheet random stuff' => undef,
);

done_testing;
