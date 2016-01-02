#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'regexp';
zci is_cached   => 1;

sub build_structured_answer {
    my ($result, $expression, $text) = @_;
    return $result,
        structured_answer => {
            id   => 'regexp',
            name => 'Answer',
            data => {
                title       => 'Regular Expression Match',
                subtitle    => "Match regular expression /$expression/ on $text",
                record_data => $result,
            },
            templates => {
                group   => 'list',
                options => {
                    content => 'record',
                },
                moreAt  => 0,
            },
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test([qw( DDG::Goodie::Regexp )],
    'regexp /(?<name>Harry|Larry) is awesome/ Harry is awesome' => build_test({
        'Full Match'         => 'Harry is awesome',
        'Named Match (name)' => 'Harry',
        'Number Match (1)'   => 'Harry',
    }, '(?<name>Harry|Larry) is awesome', 'Harry is awesome'),
    'regex /(he|she) walked away/ he walked away' => build_test({
        'Full Match'       => 'he walked away',
        'Number Match (1)' => 'he',
    }, '(he|she) walked away', 'he walked away'),
    'match regex /How are (?:we|you) (doing|today)\?/ How are you today?' => build_test({
        'Full Match'       => 'How are you today?',
        'Number Match (1)' => 'today',
    }, 'How are (?:we|you) (doing|today)\?', 'How are you today?'),
    'regexp /(.*)/ ddg' => build_test({
        'Full Match'       => 'ddg',
        'Number Match (1)' => 'ddg',
    }, '(.*)', 'ddg'),
    'regexp /foo/ foo' => build_test({
        'Full Match' => 'foo',
    }, 'foo', 'foo'),
    # Does not match.
    'regexp /foo/ bar'      => undef,
    'match /^foo$/ foo bar' => undef,
    # Should not trigger.
    'What is regex?'   => undef,
    'regex cheatsheet' => undef,
    'regex'            => undef,
);

done_testing;

