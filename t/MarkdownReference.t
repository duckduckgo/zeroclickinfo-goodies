#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'markdown_reference';
zci is_cached   => 1;

sub build_structured_answer {
    my ($result_type, $formatted_input) = @_;
    my %elements = map { $_ => 0 } (
        'header',
        'list',
        'emphasis',
        'bold',
        'blockquote',
        'image',
        'link',
    );
    $elements{$result_type} = 1;
    return $formatted_input,
        structured_answer => {
            id   => 'markdown_reference',
            name => 'Answer',
            data => {
                elements => \%elements,
                subtitle => $formatted_input,
            },
            templates => {
                group   => 'base',
                options => {
                    content => 'DDH.markdown_reference.content',
                },
            },
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
	[ 'DDG::Goodie::MarkdownReference' ],
	  # Headers
    'md header'        => build_test('header', 'Header'),
    'markdown header'  => build_test('header', 'Header'),
    'markdown headers' => build_test('header', 'Header'),
    'md header'        => build_test('header', 'Header'),
    'h1 markdown'      => build_test('header', 'Header'),
    'markdown h1'      => build_test('header', 'Header'),
    # Lists
    'markdown list' => build_test('list', 'List'),
    # Emphasis
    'markdown em' => build_test('emphasis', 'Emphasis'),
    # Bold
    'markdown strong' => build_test('bold', 'Bold'),
    # Block Quote
    'markdown blockquote' => build_test('blockquote', 'Blockquote'),
    # Image
    'markdown insert image' => build_test('image', 'Image'),
    # Links
    'markdown link' => build_test('link', 'Link'),
    # Should not trigger
    'markdown random stuff'     => undef,
    'markdown cheat sheet'      => undef,
    'markdown cheat sheet list' => undef,
);

done_testing;
